//
//  ProfileImageSize.swift
//  Pangea
//
//  Created by Lillian Cain on 11/10/23.
//

import Foundation

enum ProfileImageSize {
    case extraSmall
    case searchScreen
    case small
    case medium
    case large
    case extraLarge
    
    var dimension: CGFloat {
        switch self {
        case .extraSmall: return 50
        case .searchScreen: return 65
        case .small: return 75
        case .medium: return 95
        case .large: return 125
        case .extraLarge: return 175
            
        }
    }
}
