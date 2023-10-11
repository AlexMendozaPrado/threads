//
//  UserContentListView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/20/23.
//

import SwiftUI

struct UserContentListView: View {
    @Binding var selectedFilter: ProfileThreadFilterViewModel
    @StateObject var viewModel: UserContentListViewModel
    @Namespace var animation
    
    init(selectedFilter: Binding<ProfileThreadFilterViewModel>, user: User) {
        self._selectedFilter = selectedFilter
        self._viewModel = StateObject(wrappedValue: UserContentListViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(ProfileThreadFilterViewModel.allCases) { option in
                    VStack {
                        Text(option.title)
                            .font(.subheadline)
                            .fontWeight(selectedFilter == option ? .semibold : .regular)
                        
                        if selectedFilter == option {
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
                            selectedFilter = option
                        }
                    }
                }
            }
            .padding(.vertical, 4)
            
            LazyVStack {
                if selectedFilter == .threads {
                    if viewModel.threads.isEmpty {
                        Text(viewModel.noContentText(filter: .threads))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.threads) { thread in
                            ThreadCell(config: .thread(thread))
                        }
                        .transition(.move(edge: .leading))
                    }
                } else {
                    if viewModel.replies.isEmpty {
                        Text(viewModel.noContentText(filter: .replies))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.replies) { reply in
                            ThreadReplyCell(reply: reply)
                        }
                        .transition(.move(edge: .trailing))
                    }
                }
            }
            
            .padding(.vertical, 8)
        }
    }
}

struct UserContentListView_Previews: PreviewProvider {
    static var previews: some View {
        UserContentListView(
            selectedFilter: .constant(.threads),
            user: dev.user
        )
    }
}
