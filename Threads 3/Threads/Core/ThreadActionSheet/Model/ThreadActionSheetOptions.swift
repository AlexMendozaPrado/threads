//
//  File.swift
//  Threads
//
//  Created by Stephan Dowless on 7/20/23.
//

import Foundation

enum ThreadActionSheetOptions {
    case unfollow
    case mute
    case hide
    case report
    case block
    
    var title: String {
        switch self {
        case .unfollow:
            return "Unfollow"
        case .mute:
            return "Mute"
        case .hide:
            return "Hide"
        case .report:
            return "Report"
        case .block:
            return "Block"
        }
    }
}
