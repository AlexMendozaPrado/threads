//
//  ContentActionButtonViewModel.swift
//  Threads
//
//  Created by Stephan Dowless on 7/20/23.
//

import Foundation

@MainActor
class ContentActionButtonViewModel: ObservableObject {
    @Published var thread: Thread?
    @Published var reply: ThreadReply?
    
    init(contentType: ThreadViewConfig) {
        switch contentType {
        case .thread(let thread):
            self.thread = thread
            Task { try await checkIfUserLikedThread() }
            
        case .reply(let reply):
            self.reply = reply
        }
    }
    
    func likeThread() async throws {
        guard let thread = thread else { return }
        
        try await ThreadService.likeThread(thread)
        self.thread?.didLike = true
        self.thread?.likes += 1
    }
    
    func unlikeThread() async throws {
        guard let thread = thread else { return }

        try await ThreadService.unlikeThread(thread)
        self.thread?.didLike = false
        self.thread?.likes -= 1
    }
    
    func checkIfUserLikedThread() async throws {
        guard let thread = thread else { return }

        let didLike = try await ThreadService.checkIfUserLikedThread(thread)
        if didLike {
            self.thread?.didLike = true
        }
    }
}
