//
//  ModeButtonStyle.swift
//  Keira
//
//  Created by Matoi on 10.02.2024.
//
import SwiftUI

struct ModeButtonStyle: ButtonStyle {
    
    let scale: CGFloat
    
    init(scale: CGFloat = 0.9) {
        self.scale = scale
    }
    
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        __THIS_BUTTON(configuration: configuration, scale: self.scale)
    }
    
    struct __THIS_BUTTON: View {
        let configuration: ButtonStyle.Configuration
        let scale: CGFloat
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? scale : 1)
                .opacity(configuration.isPressed ? 0.9 : 1)
                .frame(maxWidth: .infinity)
        }
    }
}

extension View {
    
    func modeButtonStyle(scale: CGFloat = 0.9) -> some View {
        buttonStyle(StartButtonStyle(scale: scale))
    }
}
