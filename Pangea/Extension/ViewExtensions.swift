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
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.25), radius: 2.5, x: 0.5, y: 0.5)
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

#if !os(macOS)
import UIKit
#endif

@available(iOS 14.0, *)
@available(macOS 11, *)

extension Color {
    public init?(hex: String ) {
        var hexSanitized = hex.trimmingCharacters( in: .whitespacesAndNewlines )
        hexSanitized = hexSanitized.replacingOccurrences( of: "#", with: "" )
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        let length = hexSanitized.count
        guard Scanner( string: hexSanitized ).scanHexInt64( &rgb ) else { return nil }
        
        if length == 6 {
            r = CGFloat(( rgb & 0xFF0000 ) >> 16 ) / 255.0
            g = CGFloat(( rgb & 0x00FF00) >> 8 ) / 255.0
            b = CGFloat( rgb & 0x0000FF ) / 255.0
        } else if length == 8 {
            r = CGFloat(( rgb & 0xFF000000 ) >> 24 ) / 255.0
            g = CGFloat(( rgb & 0x00FF0000 ) >> 16 ) / 255.0
            b = CGFloat(( rgb & 0x0000FF00 ) >> 8 ) / 255.0
            a = CGFloat( rgb & 0x000000FF ) / 255.0
            
        } else { return nil }
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    public func toHex() throws -> String {
        
#if os(macOS)
        let cgColor = NSColor( self ).cgColor
#elseif os(iOS)
        let cgColor = UIColor( self ).cgColor
#endif
        
        guard let components = cgColor.components, components.count >= 3 else { return "Error" }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        if components.count >= 4 {
            a = Float(components[3])
        }
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    public var hexString : String? {
        return try? toHex()
    }
}

extension Array<String> {
    func hexToColorArray() -> [Color] {
        var colorArray: [Color] = []
        self.forEach { hex in
            if let hexColor = Color(hex: hex) {
                colorArray.append(hexColor)
            }
        }
        return colorArray
    }
}

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}


extension String {
func StringToColor() -> Color {
    switch self {
    case "Red" : return .red
    case "Pink" : return .pink.opacity(0.75)
    case "Orange" : return .orange
    case "Yellow" : return .yellow.opacity(0.75)
    case "Green" : return .green.opacity(0.75)
    case "Mint" : return .mint.opacity(0.75)
    case "Indigo" : return .indigo.opacity(0.75)
    case "Cyan" : return .cyan
    case "Blue" : return .blue.opacity(0.75)
    case "Purple" : return .purple.opacity(0.75)
    case "Black" : return .black
    case "Gray" : return .gray
    case "Brown" : return .brown
    case "SystemPink" : return Color(.systemPink)
    case "System Red" : return Color(.systemRed)
    case "LightOrange" : return .orange.opacity(0.5)
    case "SystemGreen" : return Color(.systemGreen)
    case "SystemMint" : return Color(.systemMint)
    case "SystemCyan" : return Color(.systemCyan)
    case "SystemBlue" : return Color(.systemBlue)
    case "SystemPurple" : return Color(.systemPurple)
        
    default: return Color(.systemGroupedBackground)
        
    }
}
}

extension Color {
func ColorToString() -> String {
    switch self {
    case .red : return "Red"
    case .pink.opacity(0.75) : return "Pink"
    case .orange : return "Orange"
    case .yellow.opacity(0.75) : return "Yellow"
    case .green.opacity(0.75) : return "Green"
    case .mint.opacity(0.75) : return "Mint"
    case .indigo.opacity(0.75) : return "Indigo"
    case .cyan : return "Cyan"
    case .blue.opacity(0.75) : return "Blue"
    case .purple.opacity(0.75) : return "Purple"
    case .black : return "Black"
    case .gray : return "Gray"
    case .brown : return "Brown"
    case Color(.systemPink) : return "SystemPink"
    case Color(.systemRed) : return "System Red"
    case .orange.opacity(0.5) : return "LightOrange"
    case Color(.systemGreen) : return "SystemGreen"
    case Color(.systemMint) : return "SystemMint"
    case Color(.systemCyan) : return "SystemCyan"
    case Color(.systemBlue) : return "SystemBlue"
    case Color(.systemPurple) : return "SystemPurple"
        
    default: return "Black"
        
    }
}
}
