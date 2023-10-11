//
//  UserListView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/18/23.
//


import SwiftUI

struct UserListView: View {
    @ObservedObject var viewModel: ExploreViewModel
    @State private var searchText = ""
    
    var users: [User] {
        return searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(users) { user in
                    NavigationLink(value: user) {
                        UserCell(user: user, viewModel: viewModel)
                            .padding(.leading)
                    }
                }
                
            }
            .navigationTitle("Search")
            .padding(.top)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(viewModel: ExploreViewModel())
    }
}
