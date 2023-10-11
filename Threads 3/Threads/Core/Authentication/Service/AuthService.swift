//
//  AuthService.swift
//  Threads
//
//  Created by Stephan Dowless on 7/16/23.
//

import Firebase

class AuthService {
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task { try await UserService.shared.fetchCurrentUser() }
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await UserService.shared.fetchCurrentUser()
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await uploadUserData(email: email, fullname: fullname, username: username, id: result.user.uid)
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    private func uploadUserData(email: String, fullname: String, username: String, id: String) async throws {
        let user = User(fullname: fullname, email: email, username: username.lowercased(), id: id)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try await FirestoreConstants.UserCollection.document(id).setData(encodedUser)
        UserService.shared.currentUser = user
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    func sendPasswordResetEmail(toEmail email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("DEBUG: Failed to send email with error \(error.localizedDescription)")
            throw error
        }
    }
}
