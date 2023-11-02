//
//  FontManager.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import Foundation
import SwiftUI

struct FontOne {
    static let body = Font.fontOne(size: 27.5)
    static let title = Font.fontOne(size: 45)
    static let small = Font.fontOne(size: 20)
    static let medium = Font.fontOne(size: 30)
    static let large = Font.fontOne(size: 35)
}

struct FontTwo {
    static let body = Font.fontTwo(size: 25)
    static let title = Font.fontTwo(size: 50)
    static let small = Font.fontTwo(size: 20)
    static let medium = Font.fontTwo(size: 30)
    static let large = Font.fontTwo(size: 35)
}

struct FontThree {
    static let body = Font.fontThree(size: 25)
    static let title = Font.fontThree(size: 45)
    static let small = Font.fontThree(size: 20)
    static let medium = Font.fontThree(size: 30)
    static let large = Font.fontThree(size: 35)
}

struct FontFour {
    static let body = Font.fontFour(size: 25)
    static let title = Font.fontFour(size: 45)
    static let small = Font.fontFour(size: 20)
    static let medium = Font.fontFour(size: 30)
    static let large = Font.fontFour(size: 35)
}

struct FontFive {
    static let body = Font.fontFive(size: 25)
    static let title = Font.fontFive(size: 45)
    static let small = Font.fontFive(size: 20)
    static let medium = Font.fontFive(size: 30)
    static let large = Font.fontFive(size: 35)
}

struct FontSix {
    static let body = Font.fontSix(size: 25)
    static let title = Font.fontSix(size: 45)
    static let small = Font.fontSix(size: 20)
    static let medium = Font.fontSix(size: 30)
    static let large = Font.fontSix(size: 35)
}

struct FontSeven {
    static let body = Font.fontSeven(size: 25)
    static let title = Font.fontSeven(size: 45)
    static let small = Font.fontSeven(size: 20)
    static let medium = Font.fontSeven(size: 30)
    static let large = Font.fontSeven(size: 35)
}

struct FontEight {
    static let body = Font.fontEight(size: 25)
    static let title = Font.fontEight(size: 45)
    static let small = Font.fontEight(size: 20)
    static let medium = Font.fontEight(size: 30)
    static let large = Font.fontEight(size: 35)
}
struct FontNine {
    static let body = Font.fontNine(size: 25)
    static let title = Font.fontNine(size: 57.5)
    static let small = Font.fontNine(size: 20)
    static let medium = Font.fontNine(size: 30)
    static let large = Font.fontNine(size: 35)
}

extension Font {
    
    static func fontOne(size: CGFloat, relativeTo style: TextStyle = .body) -> Font {
        custom("13_Misa", size: size)
    }
    
    static func fontTwo(size: CGFloat, relativeTo style: TextStyle = .body) -> Font {
        custom("Abuela Grillo", size: size)
    }
    
    static func fontThree(size: CGFloat, relativeTo style: TextStyle = .body) -> Font {
        custom("Aerobics", size: size)
    }
    
    static func fontFour(size: CGFloat, relativeTo style: TextStyle = .body) -> Font {
        custom("pallini", size: size)
    }
    
    static func fontFive(size: CGFloat, relativeTo style: TextStyle = .body) -> Font {
        custom("Trag", size: size)
    }
    
    static func fontSix(size: CGFloat, relativeTo style: TextStyle = .body) -> Font {
        custom("Views", size: size)
    }
    
    static func fontSeven(size: CGFloat, relativeTo style: TextStyle = .body) -> Font {
        custom("Orbitronio", size: size)
    }
    
    
    static func fontEight(size: CGFloat, relativeTo style: TextStyle = .body) -> Font {
        custom("almonte", size: size)
    }
    
    static func fontNine(size: CGFloat, relativeTo style: TextStyle = .body) -> Font {
        custom("5curvo", size: size)
    }
}
