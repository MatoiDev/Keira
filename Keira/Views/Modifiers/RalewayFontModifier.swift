//
//  RalewayFontModifier.swift
//  Keira
//
//  Created by Matoi on 05.12.2023.
//

import SwiftUI

enum RalewayFontWeight: String {
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case semibold = "SemiBold"
    case bold = "Bold"
}

struct RalewayFontModifier: ViewModifier {
    
    let weight: RalewayFontWeight
    let size: CGFloat
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Raleway-v4020-\(self.weight)", size: self.size))
            .foregroundColor(self.color)
    }
}

extension View {
    func ralewayFont(_ weight: RalewayFontWeight, _ size: CGFloat, color: Color = .white) -> some View {
        modifier(RalewayFontModifier(weight: weight, size: size, color: color))
    }
}


