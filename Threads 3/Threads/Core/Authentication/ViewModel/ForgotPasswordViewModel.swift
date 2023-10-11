//
//  ForgotPasswordViewModel.swift
//  Threads
//
//  Created by Stephan Dowless on 7/21/23.
//

import Foundation

@MainActor
class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var didSendEmail = false
    
    func sendPasswordResetEmail() async throws {
        try await AuthService.shared.sendPasswordResetEmail(toEmail: email)
        didSendEmail = true 
    }
}
