//
//  ActivityView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/13/23.
//

import SwiftUI

struct ActivityView: View {
    @StateObject var viewModel = ActivityViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ActivityFilterView(selectedFilter: $viewModel.selectedFilter)
                        .padding(.vertical)

                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.notifications) { activityModel in
                            if activityModel.type != .follow {
                                NavigationLink(value: activityModel) {
                                    ActivityRowView(model: activityModel)
                                }
                            } else {
                                NavigationLink(value: activityModel.user) {
                                    ActivityRowView(model: activityModel)
                                }
                            }
                        }
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("Activity")
            .navigationDestination(for: ActivityModel.self, destination: { model in
                if let thread = model.thread {
                    ThreadDetailsView(thread: thread)
                }
            })
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
