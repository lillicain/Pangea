//
//  FontManager.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import Foundation
import SwiftUI

struct FontManager {
    static let body = Font.fontOne(size: 25)
    static let title = Font.fontOne(size: 45)
    
    static let small = Font.fontOne(size: 20)
    static let medium = Font.fontOne(size: 30)
    static let large = Font.fontOne(size: 35)

}

extension Font {
    
    static func fontOne(size: CGFloat, relativeTo style: TextStyle = .body) -> Font {
        custom("", size: size)
    }
    
}
