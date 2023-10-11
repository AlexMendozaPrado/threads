//
//  ThreadReply.swift
//  Threads
//
//  Created by Stephan Dowless on 7/19/23.
//

import FirebaseFirestoreSwift
import Firebase

struct ThreadReply: Identifiable, Codable {
    @DocumentID private var replyId: String?
    let threadId: String
    let replyText: String
    let threadReplyOwnerUid: String
    let threadOwnerUid: String
    let timestamp: Timestamp
    
    var thread: Thread?
    var replyUser: User?
    
    var id: String {
        return replyId ?? NSUUID().uuidString
    }
}
