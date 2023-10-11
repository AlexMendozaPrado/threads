//
//  CreateThreadViewModel.swift
//  Threads
//
//  Created by Stephan Dowless on 7/17/23.
//

import Foundation
import Firebase

class CreateThreadViewModel: ObservableObject {
    
    @Published var caption = ""
    
    func uploadThread() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let thread = Thread(
            ownerUid: uid,
            caption: caption,
            timestamp: Timestamp(),
            likes: 0,
            replyCount: 0
        )
        try await ThreadService.uploadThread(thread)
    }
}
