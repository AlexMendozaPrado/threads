//
//  ContentViewModel.swift
//  Threads
//
//  Created by Stephan Dowless on 7/16/23.
//

import Combine
import FirebaseAuth

class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$userSession.sink { [weak self] session in
            self?.userSession = session
        }.store(in: &cancellables)
        
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
}
