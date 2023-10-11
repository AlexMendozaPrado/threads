//
//  UserService.swift
//  Threads
//
//  Created by Stephan Dowless on 7/17/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService {
    
    @Published var currentUser: User?
    
    static let shared = UserService()
    private static let userCache = NSCache<NSString, NSData>()

    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    static func fetchUser(withUid uid: String) async throws -> User {
        if let nsData = userCache.object(forKey: uid as NSString) {
            if let user = try? JSONDecoder().decode(User.self, from: nsData as Data) {
                return user
            }
        }
        
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        
        if let userData = try? JSONEncoder().encode(user) {
            userCache.setObject(userData as NSData, forKey: uid as NSString)
        }
        
        return user
    }
    
    static func fetchUsers() async throws -> [User] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await FirestoreConstants.UserCollection.getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        return users.filter({ $0.id != uid })
    }
}

// MARK: - Following

extension UserService {
    @MainActor
    func follow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirestoreConstants
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .setData([:])
        
        async let _ = try await FirestoreConstants
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
            .setData([:])
        
        ActivityService.uploadNotification(toUid: uid, type: .follow)
        
        currentUser?.stats?.followingCount += 1
        
        async let _ = try await updateUserFeedAfterFollow(followedUid: uid)
    }
    
    @MainActor
    func unfollow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirestoreConstants
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .delete()

        async let _ = try await FirestoreConstants
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
            .delete()
        
        currentUser?.stats?.followingCount -= 1
        async let _ = try await ActivityService.deleteNotification(toUid: uid, type: .follow)
        async let _ = try await updateUserFeedAfterUnfollow(unfollowedUid: uid)
    }
    
    static func checkIfUserIsFollowedWithUid(_ uid: String) async -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        let collection = FirestoreConstants.FollowingCollection.document(currentUid).collection("user-following")
        guard let snapshot = try? await collection.document(uid).getDocument() else { return false }
        return snapshot.exists
    }
    
    static func checkIfUserIsFollowed(_ user: User) async -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        let collection = FirestoreConstants.FollowingCollection.document(currentUid).collection("user-following")
        guard let snapshot = try? await collection.document(user.id).getDocument() else { return false }
        return snapshot.exists
    }
    
    static func fetchUserStats(uid: String) async throws -> UserStats {
        async let followingSnapshot = try await FirestoreConstants.FollowingCollection.document(uid).collection("user-following").getDocuments()
        let following = try await followingSnapshot.count
        
        async let followerSnapshot = try await FirestoreConstants.FollowersCollection.document(uid).collection("user-followers").getDocuments()
        let followers = try await followerSnapshot.count
        
        async let threadsSnapshot = try await FirestoreConstants.ThreadsCollection.whereField("ownerUid", isEqualTo: uid).getDocuments()
        let threadsCount = try await threadsSnapshot.count
        
        return .init(followersCount: followers, followingCount: following, threadsCount: threadsCount)
    }
        
    static func fetchUserFollowers(uid: String) async throws -> [User] {
        let snapshot = try await FirestoreConstants
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .getDocuments()
        
        return try await fetchUsers(snapshot)

    }
    
    static func fetchUserFollowing(uid: String) async throws -> [User] {
        let snapshot = try await FirestoreConstants
            .FollowingCollection
            .document(uid)
            .collection("user-following")
            .getDocuments()
        
        return try await fetchUsers(snapshot)
    }
}

// MARK: Feed Updates

extension UserService {
    func updateUserFeedAfterFollow(followedUid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let threadsSnapshot = try await FirestoreConstants.ThreadsCollection.whereField("ownerUid", isEqualTo: followedUid).getDocuments()
        
        for document in threadsSnapshot.documents {
            try await FirestoreConstants
                .UserCollection
                .document(currentUid)
                .collection("user-feed")
                .document(document.documentID)
                .setData([:])
        }
    }
    
    func updateUserFeedAfterUnfollow(unfollowedUid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let threadsSnapshot = try await FirestoreConstants.ThreadsCollection.whereField("ownerUid", isEqualTo: unfollowedUid).getDocuments()
        
        for document in threadsSnapshot.documents {
            try await FirestoreConstants
                .UserCollection
                .document(currentUid)
                .collection("user-feed")
                .document(document.documentID)
                .delete()
        }
    }
}

// MARK: - Helpers 

extension UserService {
    private static func fetchUsers(_ snapshot: QuerySnapshot?) async throws -> [User] {
        var users = [User]()
        guard let documents = snapshot?.documents else { return [] }
        
        for doc in documents {
            let user = try await UserService.fetchUser(withUid: doc.documentID)
            users.append(user)
        }
        
        return users
    }
}
