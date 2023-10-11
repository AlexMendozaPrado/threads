//
//  ActivityModel.swift
//  Threads
//
//  Created by Stephan Dowless on 7/13/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct ActivityModel: Identifiable, Codable, Hashable {
    @DocumentID private var activityModelId: String?
    let type: ActivityType
    let senderUid: String
    let timestamp: Timestamp
    var threadId: String?
    
    var user: User?
    var thread: Thread?
    var isFollowed: Bool?
    
    var id: String {
        return activityModelId ?? NSUUID().uuidString
    }
}
