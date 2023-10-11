//
//  LoginView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/14/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
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
                }
                
                NavigationLink {
                    ForgotPasswordView()
                } label: {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 28)
                        .foregroundColor(Color.theme.primaryText)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                Button {
                    Task { try await viewModel.login() }
                } label: {
                    Text(viewModel.isAuthenticating ? "" : "Login")
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
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        
                        Text("Sign Up")
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
}

// MARK: - Form Validation

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
