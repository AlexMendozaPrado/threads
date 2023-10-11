//
//  RegistrationView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/16/23.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            // logo image
            Image("threads-app-icon")
                .renderingMode(.template)
                .resizable()
                .colorMultiply(Color.theme.primaryText)
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
            
            // text fields
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(ThreadsTextFieldModifier())
                
                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(ThreadsTextFieldModifier())
                
                TextField("Enter your full name", text: $viewModel.fullname)
                    .autocapitalization(.none)
                    .modifier(ThreadsTextFieldModifier())
                
                TextField("Enter your username", text: $viewModel.username)
                    .autocapitalization(.none)
                    .modifier(ThreadsTextFieldModifier())
            }
            
            Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text(viewModel.isAuthenticating ? "" : "Sign up")
                    .foregroundColor(Color.theme.primaryBackground)
                    .modifier(ThreadsButtonModifier())
                    .overlay {
                        if viewModel.isAuthenticating {
                            ProgressView()
                                .tint(Color.theme.primaryBackground)
                        }
                    }
                    
            }
            .disabled(viewModel.isAuthenticating || !formIsValid)
            .opacity(formIsValid ? 1 : 0.7)
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    
                    Text("Sign in")
                        .fontWeight(.semibold)
                }
                .foregroundColor(Color.theme.primaryText)
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.authError?.description ?? ""))
        }
    }
}

// MARK: - Form Validation

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && !viewModel.fullname.isEmpty
        && viewModel.password.count > 5
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
