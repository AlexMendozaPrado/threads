//
//  ExploreView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/12/23.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @StateObject var viewModel = ExploreViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                UserListView(viewModel: viewModel)
                    .navigationDestination(for: User.self) { user in
                        ProfileView(user: user)
                    }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
