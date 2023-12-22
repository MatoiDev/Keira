//
//  JoystickView.swift
//  Keira
//
//  Created by Matoi on 21.12.2023.
//

import SwiftUI

struct JoystickView: View {
    
    @ObservedObject public var joystickMonitor: JoystickMonitor
    @EnvironmentObject var btVM: BTDevicesViewModel
    
    private let dragDiameter: CGFloat
    private let shape: JoystickShape
    
    public init(monitor: JoystickMonitor, width: CGFloat, shape: JoystickShape = .circle) {
        self.joystickMonitor = monitor
        self.dragDiameter = width
        self.shape = shape
    }
    
    public var body: some View {
        VStack {
            JoystickBuilder(
                monitor: self.joystickMonitor,
                width: self.dragDiameter,
                shape: self.shape,
                background: {
                    JoystickBackgroundView()
                },
                foreground: {
                    JoystickForegroundView()
                },
                locksInPlace: false)
        }
        .onChange(of: self.joystickMonitor.xyPoint.y) { newValue in
            print(newValue)
        }
    }
}

struct JoystickView_Previews: PreviewProvider {
    
    static var previews: some View {
        JoystickView(monitor: JoystickMonitor(), width: 100, shape: .circle)
    }
}
