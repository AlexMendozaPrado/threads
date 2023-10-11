//
//  ThreadReplyCell.swift
//  Threads
//
//  Created by Stephan Dowless on 7/19/23.
//

import SwiftUI

struct ThreadReplyCell: View {
    let reply: ThreadReply
    @State private var threadViewSize: CGFloat = 24
    @State private var showReplySheet = false
    
    private var thread: Thread? {
        return reply.thread
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let thread = thread {
                HStack(alignment: .top) {
                    VStack {
                        CircularProfileImageView(user: thread.user, size: .small)
                        
                        Rectangle()
                            .frame(width: 2, height: threadViewSize - 24)
                            .foregroundColor(Color(.systemGray4))
                    }
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(thread.user?.username ?? "")
                                .fontWeight(.semibold)
                            
                            Text(thread.caption)
                            
                        }
                        .font(.footnote)
                        
                        ContentActionButtonView(viewModel: ContentActionButtonViewModel(contentType: .thread(thread)))
                            .padding(.bottom, 4)
                    }
                    
                    Spacer()
                }
            }
            
            HStack(alignment: .top) {
                CircularProfileImageView(user: reply.replyUser, size: .small)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(reply.replyUser?.username ?? "")
                        .fontWeight(.semibold)
                    
                    Text(reply.replyText)
                }
                .font(.footnote)

            }
            
            Divider()
        }
        .onAppear {
            setThreadHeight()
        }
    }
    
    func setThreadHeight() {
        guard let thread = thread else { return }
        let imageHeight: CGFloat = 40
        let captionHeight = thread.caption.sizeUsingFont(usingFont: UIFont.systemFont(ofSize: 12))
        let actionButtonViewHeight: CGFloat = 40
        self.threadViewSize = imageHeight + captionHeight.height + actionButtonViewHeight
    }
}

struct ThreadReplyCell_Previews: PreviewProvider {
    static var previews: some View {
        ThreadReplyCell(reply: dev.reply)
    }
}
