//
//  FeedViewModel.swift
//  Threads
//
//  Created by Stephan Dowless on 7/18/23.
//

import Foundation
import Firebase

@MainActor
class FeedViewModel: ObservableObject {
    @Published var threads = [Thread]()
    @Published var isLoading = false
    
    init() {
        Task { try await fetchThreads() }
    }
    
    private func fetchThreadIDs() async -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        isLoading = true
        
        let snapshot = try? await FirestoreConstants
            .UserCollection
            .document(uid)
            .collection("user-feed")
            .getDocuments()
        
        return snapshot?.documents.map({ $0.documentID }) ?? []
    }
    
    func fetchThreads() async throws {
        let threadIDs = await fetchThreadIDs()

        try await withThrowingTaskGroup(of: Thread.self, body: { group in
            var threads = [Thread]()

            for id in threadIDs {
                group.addTask { return try await ThreadService.fetchThread(threadId: id) }
            }

            for try await thread in group {
                threads.append(try await fetchThreadUserData(thread: thread))
            }

            self.threads = threads.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
            isLoading = false
        })
    }
    
    private func fetchThreadUserData(thread: Thread) async throws -> Thread {
        var result = thread
    
        async let user = try await UserService.fetchUser(withUid: thread.ownerUid)
        result.user = try await user
        
        return result
    }
}
