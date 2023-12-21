//
//  StartButtonStyle.swift
//  Keira
//
//  Created by Matoi on 21.12.2023.
//

import SwiftUI

struct StartButtonStyle: ButtonStyle {
    
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
                .padding(.horizontal, 8)
                .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                .scaleEffect(configuration.isPressed ? scale : 1)
                .opacity(configuration.isPressed ? 0.9 : 1)
        }
    }
}

extension View {
    
    func startButtonStyle(scale: CGFloat = 0.9) -> some View {
        buttonStyle(StartButtonStyle(scale: scale))
    }
}
