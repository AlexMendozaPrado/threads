//
//  ThreadActionSheetView.swift
//  Threads
//
//  Created by Stephan Dowless on 7/20/23.
//

import SwiftUI

struct ThreadActionSheetView: View {
    let thread: Thread
    @State private var height: CGFloat = 200
    @State private var isFollowed = false
    @Binding var selectedAction: ThreadActionSheetOptions?
    
    var body: some View {
        List {
            Section {
                if isFollowed {
                    ThreadActionSheetRowView(option: .unfollow, selectedAction: $selectedAction)
                }
                
                ThreadActionSheetRowView(option: .mute, selectedAction: $selectedAction)
            }
            
            Section {
                ThreadActionSheetRowView(option: .report, selectedAction: $selectedAction)
                    .foregroundColor(.red)
                
                if !isFollowed {
                    ThreadActionSheetRowView(option: .block, selectedAction: $selectedAction)
                        .foregroundColor(.red)
                }
            }
        }
        
        .onAppear {
            Task {
                if let user = thread.user {
                    let isFollowed = await UserService.checkIfUserIsFollowed(user)
                    self.isFollowed = isFollowed
                    height += isFollowed ? 32 : 0
                }
            }
        }
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(12)
        .font(.footnote)
    }
}

struct ThreadActionSheetRowView: View {
    let option: ThreadActionSheetOptions
    @Environment(\.dismiss) var dismiss
    @Binding var selectedAction: ThreadActionSheetOptions?
    
    var body: some View {
        HStack {
            Text(option.title)
                .font(.footnote)
            
            Spacer()
        }
        .background(Color.theme.primaryBackground)
        .onTapGesture {
            selectedAction = option
            dismiss()
        }
    }
}

struct ThreadActionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadActionSheetView(thread: dev.thread, selectedAction: .constant(.unfollow))
    }
}
