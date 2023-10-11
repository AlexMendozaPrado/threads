//
//  ForgotPasswordView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/21/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel = ForgotPasswordViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("threads-app-icon")
                .renderingMode(.template)
                .resizable()
                .colorMultiply(Color.theme.primaryText)
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
            
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(ThreadsTextFieldModifier())
            }
            
            Button {
                Task { try await viewModel.sendPasswordResetEmail() }
            } label: {
                Text("Reset Password")
                    .foregroundColor(Color.theme.primaryBackground)
                    .modifier(ThreadsButtonModifier())
                    
            }
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1 : 0.7)
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                Text("Return to login")
                    .foregroundColor(Color.theme.primaryText)
                    .font(.footnote)
            }
            .padding(.vertical, 16)
        }
        .alert(isPresented: $viewModel.didSendEmail) {
            Alert(
                title: Text("Email sent"),
                message: Text("An email has been sent to \(viewModel.email) to reset your password"),
                dismissButton: .default(Text("Ok"), action: {
                    dismiss()
                })
            )
        }
    }
}

// MARK: - Form Validation

extension ForgotPasswordView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
