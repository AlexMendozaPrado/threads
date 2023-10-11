//
//  ProfileThreadFilterViewModel.swift
//  Threads
//
//  Created by Stephan Dowless on 7/13/23.
//

import Foundation

enum ProfileThreadFilterViewModel: Int, CaseIterable, Identifiable {
    case threads
    case replies
    
    var title: String {
        switch self {
        case .threads: return "Threads"
        case .replies: return "Replies"
        }
    }
    
    var id: Int { return self.rawValue }
}
