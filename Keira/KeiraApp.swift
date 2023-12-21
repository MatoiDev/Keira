//
//  KeiraApp.swift
//  Keira
//
//  Created by Matoi on 05.12.2023.
//

import SwiftUI


class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.all {
        didSet {
            if #available(iOS 16.0, *) {
                UIApplication.shared.connectedScenes.forEach { scene in
                    if let windowScene = scene as? UIWindowScene {
                        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationLock))
                    }
                }
                UIViewController.attemptRotationToDeviceOrientation()
            } else {
                UIViewController.attemptRotationToDeviceOrientation()
                if orientationLock == .landscape {
                    DispatchQueue.main.async {
                        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                    }
                   
                } else {
                     if Device.get() == .phone  {
                         DispatchQueue.main.async {
                             UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                         }
                    }
                }
            }
        }
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}


@main
struct KeiraApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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



