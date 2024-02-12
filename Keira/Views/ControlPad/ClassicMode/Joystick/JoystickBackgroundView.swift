//
//  JoystickBackgroundView.swift
//  Keira
//
//  Created by Matoi on 21.12.2023.
//

import SwiftUI

struct JoystickBackgroundView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.lightShadow)
                .overlay(
                    Circle()
                        .stroke(Color.dipCircle, lineWidth: 50)
                )
                .overlay(
                    Circle()
                        .stroke(Color.dipCircle, lineWidth: 35)
                        .blur(radius: 10)
                        .offset(x: 10.0, y: 10.0)
                        .mask(Circle().stroke(lineWidth: 40))
                    
                )
                .overlay(
                    Circle()
                        .stroke(Color.darkShadow.opacity(0.8), lineWidth: 35)
                        .blur(radius: 10)
                        .offset(x: -10.0, y: -10.0)
                        .mask(Circle().stroke(lineWidth: 40))
                    
                )
                .overlay(
                    Circle()
                        .stroke(Color.lightShadow.opacity(0.9), lineWidth: 35)
                        .blur(radius: 10)
                        .offset(x: 5.0, y: 5.0)
                        .mask(Circle().stroke(lineWidth: 40))
                    
                )
                .overlay(
                    Circle()
                        .stroke(Color.darkShadow.opacity(0.8), lineWidth: 35)
                        .blur(radius: 10)
                        .offset(x: -5.0, y: -5.0)
                        .mask(Circle().stroke(lineWidth: 40))
                    
                )
                .overlay(
                    Circle()
                        .stroke(Color.lightShadow, lineWidth: 6)
                        .blur(radius: 4)
                        .offset(x: 2.0, y: 2.0)
                        
                    
                )
                .overlay(
                    Circle()
                        .stroke(Color.darkShadow, lineWidth: 6)
                        .blur(radius: 4)
                        .offset(x: -2.0, y: -2.0)
                )
                .frame(width: 75, height: 75)
        }
    }
}

struct JoystickBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        JoystickBackgroundView()
    }
}

extension Color {
    static let viewbackground = Color.init(red: 42/255, green: 51/255, blue: 67/255)
    static let lightShadow = Color.init(red: 47/255, green: 56/255, blue: 74/255)
    
    static let darkShadow = Color.init(red: 13/255, green: 16/255, blue: 24/255)
    
    static let dipCircle = LinearGradient (
        gradient: Gradient (
        colors: [lightShadow.opacity(0.3),darkShadow.opacity(0.3)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let dipCircle1 = LinearGradient(
        gradient: Gradient (
        colors: [lightShadow, darkShadow]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
