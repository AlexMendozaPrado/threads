//
//  SettingsOptions.swift
//  Threads
//
//  Created by Stephan Dowless on 7/18/23.
//

import Foundation

enum SettingsOptions: Int, CaseIterable, Identifiable {
    case notifications
    case privacy
    case account
    case help
    case about
    
    var title: String {
        switch self {
        case .notifications: return "Notifications"
        case .privacy: return "Privacy"
        case .account: return "Account"
        case .help: return "Help"
        case .about: return "About"
        }
    }
    
    var imageName: String {
        switch self {
        case .notifications: return "bell"
        case .privacy: return "lock"
        case .account: return "person.circle"
        case .help: return "questionmark.circle"
        case .about: return "info.circle"
        }
    }
    
    var id: Int { return self.rawValue }
}
