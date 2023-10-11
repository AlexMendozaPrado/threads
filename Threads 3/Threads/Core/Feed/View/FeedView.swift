//
//  FeedView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/12/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.threads) { thread in
                        NavigationLink(value: thread) {
                            ThreadCell(config: .thread(thread))
                        }
                    }
                    .padding(.top)
                }
            }
            .refreshable {
                Task { try await viewModel.fetchThreads() }
            }
            .overlay {
                if viewModel.isLoading { ProgressView() }
            }
            .navigationDestination(for: User.self, destination: { user in
                if user.isCurrentUser {
                    CurrentUserProfileView(didNavigate: true)
                } else {
                    ProfileView(user: user)
                }
            })
            .navigationDestination(for: Thread.self, destination: { thread in
                ThreadDetailsView(thread: thread)
            })
            .navigationTitle("Threads")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { try await viewModel.fetchThreads() }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(Color.theme.primaryText)
                    }

                }
            }
            .padding([.top, .horizontal])
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
