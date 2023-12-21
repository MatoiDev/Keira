//
//  JoystickForegroundView.swift
//  Keira
//
//  Created by Matoi on 21.12.2023.
//

import SwiftUI

struct JoystickForegroundView: View {
    var body: some View {
        Circle()
            .fill(Color.lightShadow)
            .overlay(
                Circle()
                    .stroke (Color.dipCircle1, lineWidth: 20)
                    .blur(radius: 5)
            )
            .frame(width: 40, height: 40)
        
        Circle()
            .fill(Color.viewbackground)
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                    .blur(radius: 4)
                    .offset(x: 2, y: 2)
                    .mask(Circle())
            )
            .overlay(
                Circle()
                    .stroke(Color.black.opacity(0.8), lineWidth: 4)
                    .blur(radius: 4)
                    .offset(x: -2, y: -2)
                    .mask(Circle())
            )
            .frame(width: 60, height: 60)
        
        KnobTopCircles()
    }
}

struct KnobTopCircles: View {
    var body: some View {
        ZStack {
            KnobView()
                .offset(x: 20)
            KnobView()
                .offset(x: -20)
            KnobView()
                .offset(y: 20)
            KnobView()
                .offset(y: -20)
            
        }
    }
}

struct KnobView: View {
    var body: some View {
        Circle()
            .fill(Color.clear)
            .overlay(
                Circle()
                    .stroke(Color.lightShadow, lineWidth: 4)
                    .blur(radius: 4)
                    .offset(x: 2, y: 2)
                    .mask(Circle())
            )
            .overlay(
                Circle()
                    .stroke(Color.darkShadow, lineWidth: 4)
                    .blur(radius: 4)
                    .offset(x: -2, y: -2)
                    .mask(Circle())
            )
            .frame(width: 5.3, height: 5.3)
    }
}

struct JoystickForegroundView_Previews: PreviewProvider {
    static var previews: some View {
        JoystickForegroundView()
    }
}
