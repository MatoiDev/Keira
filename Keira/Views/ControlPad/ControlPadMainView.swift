//
//  ControlPadMain.swift
//  Keira
//
//  Created by Matoi on 21.12.2023.
//

import SwiftUI


struct ControlPadMainView: View {
    
    @StateObject private var leftJoystickMonitor : JoystickMonitor = JoystickMonitor()
    @StateObject private var rightJoystickMonitor : JoystickMonitor = JoystickMonitor()
    
    @State private var text: String = ""
    
    @EnvironmentObject private var btVM: BTDevicesViewModel
    @EnvironmentObject var popupVM: PopupViewModel
    
    private let _vm: ControlPadMainViewModel = ControlPadMainViewModel()
    
    var body: some View {
        ZStack {
            UIExternalKeyboardHandlerRepresentable(leftJS: self.leftJoystickMonitor, rightJS: self.rightJoystickMonitor)
            Color.viewbackground.ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    JoystickView(monitor: self.leftJoystickMonitor, width: 100, shape: .circle)
                    Spacer()
                    JoystickView(monitor: self.rightJoystickMonitor, width: 100, shape: .circle)
                    
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
            self.popupVM.popupCase = .loadControl
            self.popupVM.showPopup()
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
