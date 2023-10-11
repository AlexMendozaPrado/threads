//
//  ThreadDetailsViewModel.swift
//  Threads
//
//  Created by Stephan Dowless on 7/19/23.
//

import Foundation
import Firebase

@MainActor
class ThreadDetailsViewModel: ObservableObject {
    @Published var thread: Thread
    @Published var replies = [ThreadReply]()
    
    init(thread: Thread) {
        self.thread = thread
        setThreadUserIfNecessary()
        Task { try await fetchThreadReplies() }
    }
    
    private func setThreadUserIfNecessary() {
        guard thread.user == nil else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if thread.ownerUid == currentUid {
            thread.user = UserService.shared.currentUser
        }
    }
    
    func fetchThreadReplies() async throws {
        self.replies = try await ThreadService.fetchThreadReplies(forThread: thread)
        
        await withThrowingTaskGroup(of: Void.self, body: { group in
            for reply in replies {
                group.addTask { try await self.fetchUserData(forReply: reply) }
            }
        })
    }
    
    private func fetchUserData(forReply reply: ThreadReply) async throws {
        guard let replyIndex = replies.firstIndex(where: { $0.id == reply.id }) else { return }
        
        async let user = UserService.fetchUser(withUid: reply.threadReplyOwnerUid)
        self.replies[replyIndex].replyUser = try await user
    }
}
