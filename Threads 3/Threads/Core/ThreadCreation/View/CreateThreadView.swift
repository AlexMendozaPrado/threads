//
//  CreateThreadView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/13/23.
//

import SwiftUI

struct CreateThreadView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = CreateThreadViewModel()
    @Binding var tabIndex: Int
    
    private var user: User? {
        return UserService.shared.currentUser
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    CircularProfileImageView(user: user, size: .small)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user?.username ?? "")
                            .fontWeight(.semibold)
                        
                        TextField("Start a thread...", text: $viewModel.caption, axis: .vertical)
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    if !viewModel.caption.isEmpty {
                        Button {
                            viewModel.caption = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color.theme.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        Task {
                            try await viewModel.uploadThread()
                            dismiss()
                        }
                    }
                    .opacity(viewModel.caption.isEmpty ? 0.5 : 1.0)
                    .disabled(viewModel.caption.isEmpty)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.theme.primaryText)
                }
            }
            .onDisappear { tabIndex = 0 }
            .navigationTitle("New Thread")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreateThreadView_Previews: PreviewProvider {
    static var previews: some View {
        CreateThreadView(tabIndex: .constant(0))
    }
}
