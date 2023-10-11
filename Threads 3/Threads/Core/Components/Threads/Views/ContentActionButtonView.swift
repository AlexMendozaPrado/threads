//
//  ContentActionButtonView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/19/23.
//

import SwiftUI

struct ContentActionButtonView: View {
    @ObservedObject var viewModel: ContentActionButtonViewModel
    @State private var showReplySheet = false 
    
    private var didLike: Bool {
        return viewModel.thread?.didLike ?? false
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 16) {
                Button {
                    handleLikeTapped()
                } label: {
                    Image(systemName: didLike ? "heart.fill" : "heart")
                        .foregroundColor(didLike ? .red : Color.theme.primaryText)
                }
                
                Button {
                    showReplySheet.toggle()
                } label: {
                    Image(systemName: "bubble.right")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.rectanglepath")
                        .resizable()
                        .frame(width: 18, height: 16)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "paperplane")
                        .imageScale(.small)
                }

            }
            .foregroundStyle(Color.theme.primaryText)
            
            HStack(spacing: 4) {
                if let thread = viewModel.thread {
                    if thread.replyCount > 0 {
                        Text("\(thread.replyCount) replies")
                    }
                    
                    if thread.replyCount > 0 && thread.likes > 0 {
                        Text("-")
                    }
                    
                    if thread.likes > 0 {
                        Text("\(thread.likes) likes")
                    }
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.vertical, 4)
        }
        .sheet(isPresented: $showReplySheet) {
            if let thread = viewModel.thread {
                ThreadReplyView(thread: thread)
            }
        }
    }
    
    private func handleLikeTapped() {
        Task {
            if didLike {
                try await viewModel.unlikeThread()
            } else {
                try await viewModel.likeThread()
            }
        }
    }
}

struct ContentActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ContentActionButtonView(viewModel: ContentActionButtonViewModel(contentType: .thread(dev.thread)))
    }
}
