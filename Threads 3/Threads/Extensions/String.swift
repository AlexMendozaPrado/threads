//
//  String.swift
//  Threads
//
//  Created by Stephan Dowless on 7/19/23.
//

import UIKit

extension String {
   func sizeUsingFont(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
