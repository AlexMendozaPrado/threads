//
//  Color.swift
//  Threads
//
//  Created by Stephan Dowless on 7/20/23.
//

import SwiftUI

extension Color {
    static var theme = ColorTheme() 
}

struct ColorTheme {
    let pink = Color("Pink")
    let purple = Color("Purple")
    let primaryText = Color("PrimaryText")
    let primaryBackground = Color("PrimaryBackground")
}
