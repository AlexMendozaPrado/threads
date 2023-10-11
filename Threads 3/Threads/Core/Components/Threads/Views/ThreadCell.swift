//
//  FeedCell.swift
//  Threads
//
//  Created by Stephan Dowless on 7/12/23.
//

import SwiftUI

enum ThreadViewConfig {
    case thread(Thread)
    case reply(ThreadReply)
}

struct ThreadCell: View {
    let config: ThreadViewConfig
    @State private var showThreadActionSheet = false
    @State private var selectedThreadAction: ThreadActionSheetOptions?
    
    private var user: User? {
        switch config {
        case .thread(let thread):
            return thread.user
        case .reply(let threadReply):
            return threadReply.replyUser
        }
    }
    
    private var caption: String {
        switch config {
        case .thread(let thread):
            return thread.caption
        case .reply(let threadReply):
            return threadReply.replyText
        }
    }
    
    private var timestampString: String {
        switch config {
        case .thread(let thread):
            return thread.timestamp.timestampString()
        case .reply(let threadReply):
            return threadReply.timestamp.timestampString()
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                NavigationLink(value: user) {
                    CircularProfileImageView(user: user, size: .small)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(user?.username ?? "")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(timestampString)
                            .font(.caption)
                            .foregroundStyle(Color(.systemGray3))
                        
                        Button {
                            showThreadActionSheet.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(Color(.darkGray))
                        }
                    }
                    
                    Text(caption)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                    
                    ContentActionButtonView(viewModel: ContentActionButtonViewModel(contentType: config))
                        .padding(.top, 12)
                }
            }
            .sheet(isPresented: $showThreadActionSheet) {
                if case .thread(let thread) = config {
                    ThreadActionSheetView(thread: thread, selectedAction: $selectedThreadAction)
                }
            }

            Divider()
        }
        .onChange(of: selectedThreadAction, perform: { newValue in
            switch newValue {
            case .block:
                print("DEBUG: Block user here..")
            case .hide:
                print("DEBUG: Hide thread here..")
            case .mute:
                print("DEBUG: Mute threads here..")
            case .unfollow:
                print("DEBUG: Unfollow here..")
            case .report:
                print("DEBUG: Report thread here..")
            case .none:
                break
            }
        })
        .foregroundColor(Color.theme.primaryText)
    }
}

struct FeedCell_Previews: PreviewProvider {
    static var previews: some View {
        ThreadCell(config: .thread(dev.thread))
    }
}
