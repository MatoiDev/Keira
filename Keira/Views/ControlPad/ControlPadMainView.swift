//
//  ControlPadMain.swift
//  Keira
//
//  Created by Matoi on 21.12.2023.
//

import SwiftUI

struct ControlPadMainView: View {
    
    @StateObject var leftJoystickMonitor : JoystickMonitor = JoystickMonitor()
    @StateObject private var rightJoystickMonitor : JoystickMonitor = JoystickMonitor()
    
    var body: some View {
        ZStack {
            Color.viewbackground.ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    JoystickView(monitor: self.leftJoystickMonitor, width: 100, shape: .rect)
                    Spacer()
                    JoystickView(monitor: self.rightJoystickMonitor, width: 100, shape: .rect)
                    
                }
                .padding(Device.set(padnmac: 32, phone: 16))
                .padding(.horizontal, Device.set(padnmac: 32, phone: 0))
                .padding(.vertical, Device.set(padnmac: 16, phone: 0))
            }

        }
        .onAppear() {
            AppDelegate.orientationLock = .landscape
        }
        .onDisappear() {
            AppDelegate.orientationLock = .all
        }
    }
}

struct ControlPadMainView_Previews: PreviewProvider {
    static var previews: some View {
        ControlPadMainView()
    }
}
