//
//  UserRelationsView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/21/23.
//

import SwiftUI

struct UserRelationsView: View {
    @StateObject var viewModel: UserRelationsViewModel
    @State private var searchText = ""
    @Namespace var animation
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: UserRelationsViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            // filter view
            HStack {
                ForEach(UserRelationType.allCases) { type in
                    VStack {
                        Text(type.title)
                        
                        if viewModel.selectedFilter == type {
                            Rectangle()
                                .foregroundStyle(Color.theme.primaryText)
                                .frame(width: 180, height: 1)
                                .matchedGeometryEffect(id: "item", in: animation)
                        } else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(width: 180, height: 1)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            viewModel.selectedFilter = type
                        }
                    }
                }
            }
                        
            ScrollView {
                LazyVStack {
                    Text(viewModel.currentStatString)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(4)
                    
                    ForEach(viewModel.users) { user in
                        UserCell(user: user, viewModel: ExploreViewModel())
                    }
                }
                .searchable(text: $searchText, prompt: "Search...")
            }
        }
        .padding()
    }
}

struct UserRelationsView_Previews: PreviewProvider {
    static var previews: some View {
        UserRelationsView(user: dev.user)
    }
}
