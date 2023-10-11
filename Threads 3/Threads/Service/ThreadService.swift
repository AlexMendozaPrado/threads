//
//  ThreadService.swift
//  Threads
//
//  Created by Stephan Dowless on 7/17/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct ThreadService {
    static func uploadThread(_ thread: Thread) async throws {
        guard let threadData = try? Firestore.Encoder().encode(thread) else { return }
        let ref = try await FirestoreConstants.ThreadsCollection.addDocument(data: threadData)
        try await updateUserFeedsAfterPost(threadId: ref.documentID)
    }
    
    static func fetchThreads() async throws -> [Thread] {        
        let snapshot = try await FirestoreConstants
            .ThreadsCollection
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Thread.self) })
    }
    
    static func fetchUserThreads(uid: String) async throws -> [Thread] {
        let query = FirestoreConstants.ThreadsCollection.whereField("ownerUid", isEqualTo: uid)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: Thread.self) })
    }
    
    static func fetchThread(threadId: String) async throws -> Thread {
        let snapshot = try await FirestoreConstants.ThreadsCollection.document(threadId).getDocument()
        let thread = try snapshot.data(as: Thread.self)
        return thread
    }
}

// MARK: - Replies

extension ThreadService {
    static func replyToThread(_ thread: Thread, replyText: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let reply = ThreadReply(
            threadId: thread.id,
            replyText: replyText,
            threadReplyOwnerUid: currentUid,
            threadOwnerUid: thread.ownerUid,
            timestamp: Timestamp()
        )
        
        guard let data = try? Firestore.Encoder().encode(reply) else { return }
        try await FirestoreConstants.RepliesCollection.document().setData(data)
        try await FirestoreConstants.ThreadsCollection.document(thread.id).updateData([
            "replyCount": thread.replyCount + 1
        ])
        
        ActivityService.uploadNotification(toUid: thread.ownerUid, type: .reply, threadId: thread.id)
    }
    
    static func fetchThreadReplies(forThread thread: Thread) async throws -> [ThreadReply] {
        let snapshot = try await FirestoreConstants.RepliesCollection.whereField("threadId", isEqualTo: thread.id).getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: ThreadReply.self) })
    }
    
    static func fetchThreadReplies(forUser user: User) async throws -> [ThreadReply] {
       let snapshot = try await  FirestoreConstants
            .RepliesCollection
            .whereField("threadReplyOwnerUid", isEqualTo: user.id)
            .getDocuments()
        
        var replies = snapshot.documents.compactMap({ try? $0.data(as: ThreadReply.self) })
        
        for i in 0 ..< replies.count {
            replies[i].replyUser = user
        }
        
        return replies
    }
}

// MARK: - Likes

extension ThreadService {
    static func likeThread(_ thread: Thread) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirestoreConstants.ThreadsCollection.document(thread.id).collection("thread-likes").document(uid).setData([:])
        async let _ = try await FirestoreConstants.ThreadsCollection.document(thread.id).updateData(["likes": thread.likes + 1])
        async let _ = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(thread.id).setData([:])
        
        ActivityService.uploadNotification(toUid: thread.ownerUid, type: .like, threadId: thread.id)
    }
    
    static func unlikeThread(_ thread: Thread) async throws {
        guard thread.likes > 0 else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirestoreConstants.ThreadsCollection.document(thread.id).collection("thread-likes").document(uid).delete()
        async let _ = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(thread.id).delete()
        async let _ = try await FirestoreConstants.ThreadsCollection.document(thread.id).updateData(["likes": thread.likes - 1])
        
        async let _ = try await ActivityService.deleteNotification(toUid: thread.ownerUid, type: .like, threadId: thread.id)
    }
    
    static func checkIfUserLikedThread(_ thread: Thread) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(thread.id).getDocument()
        return snapshot.exists
    }
}

// MARK: - Feed Updates

extension ThreadService {
    private static func updateUserFeedsAfterPost(threadId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let followersSnapshot = try await FirestoreConstants.FollowersCollection.document(uid).collection("user-followers").getDocuments()
        
        for document in followersSnapshot.documents {
            try await FirestoreConstants
                .UserCollection
                .document(document.documentID)
                .collection("user-feed")
                .document(threadId).setData([:])
        }
        
        try await FirestoreConstants.UserCollection.document(uid).collection("user-feed").document(threadId).setData([:])
    }
}
