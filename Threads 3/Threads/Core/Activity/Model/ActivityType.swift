//
//  ActivityType.swift
//  Threads
//
//  Created by Stephan Dowless on 7/13/23.
//

import Foundation

enum ActivityType: Int, CaseIterable, Identifiable, Codable {
    case like
    case reply
    case follow
    
    var id: Int { return self.rawValue }
}
