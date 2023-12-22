//
//  ControlPadMain.swift
//  Keira
//
//  Created by Matoi on 21.12.2023.
//

import SwiftUI
import Combine

class ControlPadMainViewModel {
    
    private var cancellables: Set<AnyCancellable> = []
    private let updateInterval: TimeInterval = 0.05
    
    enum Side {
        case right, left
    }
    
    private var lastUpdateTime: Date = Date()
    
    func convert(coordinates: CGPoint, vm: BTDevicesViewModel, side: ControlPadMainViewModel.Side) {
        let currentTime = Date()
        
        if currentTime.timeIntervalSince(lastUpdateTime) >= updateInterval {
            let newX: UInt8 = UInt8((coordinates.x + 100) * 255 / 200)
            let newY: UInt8 = UInt8((coordinates.y + 100) * 255 / 200)
            
            if side == .left {
                vm.updateLeftJoystickValue(x: newX, y: newY)
            } else if side == .right {
                vm.updateRightJoystickValue(x: newX, y: newY)
            }
            
            lastUpdateTime = currentTime
        }
    }
    
}

struct ControlPadMainView: View {
    
    @StateObject var leftJoystickMonitor : JoystickMonitor = JoystickMonitor()
    @StateObject private var rightJoystickMonitor : JoystickMonitor = JoystickMonitor()
    
    @State private var text: String = ""
    
    @EnvironmentObject var btVM: BTDevicesViewModel
    
    private let _vm: ControlPadMainViewModel = ControlPadMainViewModel()
    
    var body: some View {
        ZStack {
            Color.viewbackground.ignoresSafeArea()
            VStack {
                TextField(text: self.$text) {
                    Text("Some message")
                }
                .background(Color.black)
                .foregroundColor(.white)
                .onSubmit {
                    self.btVM.sendMessage(msg: self.text)
                }
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
        .onChange(of: self.rightJoystickMonitor.xyPoint, perform: { coordinates in
            self._vm.convert(coordinates: coordinates, vm: self.btVM, side: .right)
        })
        .onChange(of: self.leftJoystickMonitor.xyPoint, perform: { coordinates in
            self._vm.convert(coordinates: coordinates, vm: self.btVM, side: .left)
        })
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
