//
//  ThreadReplyViewModel.swift
//  Threads
//
//  Created by Stephan Dowless on 7/19/23.
//

import Foundation

class ThreadReplyViewModel: ObservableObject {
    
    func uploadThreadReply(toThread thread: Thread, replyText: String) async throws {
        try await ThreadService.replyToThread(thread, replyText: replyText)
    }
}
