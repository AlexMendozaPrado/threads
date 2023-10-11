//
//  Thread.swift
//  Threads
//
//  Created by Stephan Dowless on 7/12/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Thread: Identifiable, Codable, Hashable {
    @DocumentID private var threadId: String?
    let ownerUid: String
    let caption: String
    let timestamp: Timestamp
    var likes: Int
    var imageUrl: String?
    var replyCount: Int
    
    var user: User?
    var didLike: Bool? = false
    
    var id: String {
        return threadId ?? NSUUID().uuidString
    }
}

