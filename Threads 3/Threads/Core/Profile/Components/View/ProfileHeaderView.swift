//
//  ProfileHeaderView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/17/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var viewModel: CurrentUserProfileViewModel
    
    private var user: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(user?.fullname ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(user?.username ?? "")
                }
                
                if let bio = user?.bio {
                    Text(bio)
                        .font(.footnote)
                }
                
                Text("22k followers")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            CircularProfileImageView(user: user, size: .medium)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView()
            .environmentObject(CurrentUserProfileViewModel())
    }
}
