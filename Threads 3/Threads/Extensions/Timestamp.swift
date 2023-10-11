//
//  Timestamp.swift
//  Threads
//
//  Created by Stephan Dowless on 7/20/23.
//

import Firebase
import Foundation

extension Timestamp {
    func timestampString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self.dateValue(), to: Date()) ?? ""
    }
}
