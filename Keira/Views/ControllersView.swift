//
//  ControllersView.swift
//  Keira
//
//  Created by Matoi on 06.12.2023.
//

import SwiftUI
import CoreBluetooth

struct ControllersView: View {
    
    @EnvironmentObject var btVM: BTDevicesViewModel
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Raleway-v4020-Bold", size: Device.set(padnmac: 48, phone: 30))!]
    }

    var body: some View {
        
        List(self.btVM.peripherals, id: \.self) { peripheral in
            BTDeviceCell(with: peripheral)
        }
        .navigationBarTitle("Select Device")
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if self.btVM.devicesReloadingState == .reloading {
                    ProgressView()
                } else {
                    EmptyView()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.btVM.reloadDevices()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
                .foregroundColor(self.btVM.devicesReloadingState == .reloading ? .gray : .accentColor)
                .disabled(self.btVM.devicesReloadingState == .reloading)
            }
            
        }
    }
}

struct ControllersView_Previews: PreviewProvider {
    static var previews: some View {
        ControllersView()
    }
}
