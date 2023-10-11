//
//  ThreadReplyView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/18/23.
//

import SwiftUI

struct ThreadReplyView: View {
    let thread: Thread
    @State private var replyText = ""
    @State private var threadViewSize: CGFloat = 24
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ThreadReplyViewModel()
    
    private var currentUser: User? {
        return UserService.shared.currentUser
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack(alignment: .top) {
                        VStack {
                            CircularProfileImageView(user: thread.user, size: .small)

                            Rectangle()
                                .frame(width: 2, height: threadViewSize - 24)
                                .foregroundColor(Color(.systemGray4))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(thread.user?.username ?? "")
                                .fontWeight(.semibold)
                            
                            Text(thread.caption)
                                .multilineTextAlignment(.leading)
                        }
                        .font(.footnote)
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .top) {
                        CircularProfileImageView(user: currentUser, size: .small)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentUser?.username ?? "")
                                .fontWeight(.semibold)
                            
                            TextField("Add your reply...", text: $replyText, axis: .vertical)
                                .multilineTextAlignment(.leading)
                            
                        }
                        .font(.footnote)
                        
                        Spacer()
                        
                        if !replyText.isEmpty {
                            Button {
                                replyText = ""
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
                .navigationTitle("Reply")
                .navigationBarTitleDisplayMode(.inline)
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
                                try await viewModel.uploadThreadReply(toThread: thread, replyText: replyText)
                                dismiss()
                            }
                        }
                        .opacity(replyText.isEmpty ? 0.5 : 1.0)
                        .disabled(replyText.isEmpty)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.theme.primaryText)
                    }
                }
            }
        }
        .onAppear { setThreadViewHeight() }
    }
    
    func setThreadViewHeight() {
        let imageHeight: CGFloat = 40
        let captionSize = thread.caption.sizeUsingFont(usingFont: UIFont.systemFont(ofSize: 12))
        
        self.threadViewSize = captionSize.height + imageHeight
    }
}

struct ThreadReplyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ThreadReplyView(thread: dev.thread)
        }
    }
}


