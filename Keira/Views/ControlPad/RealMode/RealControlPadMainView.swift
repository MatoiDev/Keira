//
//  RealControlPadMainView.swift
//  Keira
//
//  Created by Matoi on 12.02.2024.
//

import SwiftUI

struct RealControlPadMainView: View {
    
    @State private var text: String = ""
    
    @EnvironmentObject private var btVM: BTDevicesViewModel
    @EnvironmentObject var popupVM: PopupViewModel
    
    @State var shiftedGear: ShiftedGear = .neutral
    
    private let _vm: ClassicControlPadMainViewModel = ClassicControlPadMainViewModel()
    
    var body: some View {
        ZStack {
            Color.viewbackground.ignoresSafeArea()
            HStack(alignment: .top) {
                Spacer()
                VStack {
                    GearboxView(shiftedGear: self.$shiftedGear)
                        .frame(width: 180, height: 180)
                        .scaleEffect(0.5)
                    Spacer()
                    SteeringView()
                }
               
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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

struct RealControlPadMainView_Previews: PreviewProvider {
    static var previews: some View {
        RealControlPadMainView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
