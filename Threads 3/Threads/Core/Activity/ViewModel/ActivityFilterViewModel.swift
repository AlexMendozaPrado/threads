//
//  ActivityFilterViewModel.swift
//  Threads
//
//  Created by Stephan Dowless on 7/13/23.
//

import Foundation

enum ActivityFilterViewModel: Int, CaseIterable, Identifiable, Codable {
    case all
    case replies

    var title: String {
        switch self {
        case .all: return "All"
        case .replies: return "Replies"
        }
    }
    
    var id: Int { return self.rawValue }
}
