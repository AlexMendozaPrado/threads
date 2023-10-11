//
//  LoginViewModel.swift
//  Threads
//
//  Created by Stephan Dowless on 7/14/23.
//

import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticating = false
    @Published var showAlert = false
    @Published var authError: AuthError?
    
    @MainActor
    func login() async throws {
        isAuthenticating = true
        
        do {
            try await AuthService.shared.login(withEmail: email, password: password)
            isAuthenticating = false
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            isAuthenticating = false
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
        }
    }
}
