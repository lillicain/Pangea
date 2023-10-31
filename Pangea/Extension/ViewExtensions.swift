//
//  ViewManager.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import Foundation
import SwiftUI

struct MaterialViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 50)
            .background(.ultraThinMaterial)
            .cornerRadius(7.5)
            .shadow(color: .black.opacity(0.25), radius: 0.5)
            .padding()
    }
}

struct DarkModeViewModifier: ViewModifier {
    @AppStorage("appearance") var appearance: Bool = false
    
    func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, appearance ? .dark : .light)
            .preferredColorScheme(appearance ? .dark : .light)
    }
}

enum ProfileImageSize {
    case extraSmall
    case small
    case medium
    case large
    case extraLarge
    
    var dimension: CGFloat {
        switch self {
        case .extraSmall: return 50
        case .small: return 75
        case .medium: return 95
        case .large: return 125
        case .extraLarge: return 150
        }
    }
}
