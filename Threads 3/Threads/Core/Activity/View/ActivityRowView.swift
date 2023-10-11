//
//  ActivityRowView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/13/23.
//

import SwiftUI

struct ActivityRowView: View {
    let model: ActivityModel
    
    private var activityMessage: String {
        switch model.type {
        case .like:
            return model.thread?.caption ?? ""
        case .follow:
            return "Followed you"
        case .reply:
            return "Replied to one of your threads"
        }
    }
    
    private var isFollowed: Bool {
        return model.user?.isFollowed ?? false
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 16) {
                NavigationLink(value: model.user) {
                    ZStack(alignment: .bottomTrailing) {
                        CircularProfileImageView(user: model.user, size: .medium)
                        ActivityBadgeView(type: model.type)
                            .offset(x: 8, y: 4)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text(model.user?.username ?? "")
                            .bold()
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text(model.timestamp.timestampString())
                            .foregroundColor(.gray)
                    }
                    
                    Text(activityMessage)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .font(.footnote)
                
                Spacer()
                
                if model.type == .follow {
                    Button {
                        
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
            .padding(.vertical, 8)
            
            Divider()
                .padding(.leading, 80)
        }
    }
}

struct ActivityRowView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRowView(model: dev.activityModel)
    }
}
