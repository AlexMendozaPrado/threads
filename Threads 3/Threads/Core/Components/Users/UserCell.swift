//
//  UserCell.swift
//  Threads
//
//  Created by Stephan Dowless on 7/18/23.
//

import SwiftUI

struct UserCell: View {
    let user: User
    @ObservedObject var viewModel: ExploreViewModel
    
    private var isFollowed: Bool {
        return user.isFollowed ?? false
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                CircularProfileImageView(user: user, size: .small)
                
                VStack(alignment: .leading) {
                    Text(user.username)
                        .bold()
                    
                    Text(user.fullname)
                }
                .font(.footnote)
                
                Spacer()
                
                if !user.isCurrentUser {
                    Button {
    viewModel.toggleFollow(for: user)
} label: {
                        Text(isFollowed ? "Following" : "Follow")
                            .foregroundStyle(isFollowed ? Color(.systemGray4) : Color.theme.primaryText)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 100, height: 32)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                    }
                }

            }
            .padding(.horizontal)
            
            Divider()
        }
        .padding(.vertical, 4)
        .foregroundColor(Color.theme.primaryText)
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(user: dev.user, viewModel: ExploreViewModel())
    }
}
    
