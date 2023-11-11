//
//  ViewManager.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import Foundation
import SwiftUI

struct DarkModeViewModifier: ViewModifier {
    @AppStorage("appearance") var appearance: Bool = false
    
    func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, appearance ? .dark : .light)
            .preferredColorScheme(appearance ? .dark : .light)
    }
}

struct MaterialViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 50)
            .background(.ultraThinMaterial.opacity(0.5))
            .cornerRadius(15)
            .padding()
    }
}

struct ButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 275, height: 62.5)
            .background(.ultraThinMaterial.opacity(0.25))
            .cornerRadius(25)
            .shadow(color: .white.opacity(0.25), radius: 0.5, x: 0.5, y: -0.5)
            .padding()
    }
}

struct OneViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(35)
            .background(.white)
            .font(.system(size: 17.5).bold())
            .foregroundColor(AuthenticationViewModel().blue[0])
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .circular))
            .padding()
            .background(
        RoundedRectangle(cornerRadius: 25, style: .circular)
            .foregroundColor(AuthenticationViewModel().green[0])
            .frame(width: 350, height: 100)
        )
    }
}

struct PostViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12.5)
            .background(.white)
            .font(FontOne.small)
            .foregroundColor(AuthenticationViewModel().blue[0])
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .circular))
            .background(
        RoundedRectangle(cornerRadius: 25, style: .circular)
            .foregroundColor(AuthenticationViewModel().green[0])
            .frame(width: 175, height: 57.5)
        )
    }
}

