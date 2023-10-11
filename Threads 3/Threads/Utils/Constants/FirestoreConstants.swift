//
//  FirestoreConstants.swift
//  Threads
//
//  Created by Stephan Dowless on 7/16/23.
//

import Firebase

struct FirestoreConstants {
    private static let Root = Firestore.firestore()
    
    static let UserCollection = Root.collection("users")
    
    static let ThreadsCollection = Root.collection("threads")
    
    static let FollowersCollection = Root.collection("followers")
    static let FollowingCollection = Root.collection("following")

    static let RepliesCollection = Root.collection("replies")
    
    static let ActivityCollection = Root.collection("activity")
}
