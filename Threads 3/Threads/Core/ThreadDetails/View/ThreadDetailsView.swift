//
//  ThreadDetailsView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/19/23.
//

import SwiftUI

struct ThreadDetailsView: View {
    @State private var showReplySheet = false
    @StateObject var viewModel: ThreadDetailsViewModel
    
    private var thread: Thread {
        return viewModel.thread
    }
    
    init(thread: Thread) {
        self._viewModel = StateObject(wrappedValue: ThreadDetailsViewModel(thread: thread))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    CircularProfileImageView(user: thread.user, size: .small)
                    
                    Text(thread.user?.username ?? "")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("12m")
                        .font(.caption)
                        .foregroundStyle(Color(.systemGray3))
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color(.darkGray))
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(thread.caption)
                        .font(.subheadline)
                    
                    ContentActionButtonView(viewModel: ContentActionButtonViewModel(contentType: .thread(thread)))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
                .padding(.vertical)
            
            LazyVStack(spacing: 16) {
                ForEach(viewModel.replies) { reply in
                    ThreadCell(config: .reply(reply))
                }
            }
        }
        .sheet(isPresented: $showReplySheet, content: {
            ThreadReplyView(thread: thread)
        })
        .padding()
        .navigationTitle("Thread")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ThreadDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadDetailsView(thread: dev.thread)
    }
}
