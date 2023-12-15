//
//  KeiraApp.swift
//  Keira
//
//  Created by Matoi on 05.12.2023.
//

import SwiftUI

@main
struct KeiraApp: App {
    
    @StateObject var btVM: BTDevicesViewModel = BTDevicesViewModel()
    @StateObject var popupVM: PopupViewModel = PopupViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.btVM)
                .environmentObject(self.popupVM)
        }
    }
}
