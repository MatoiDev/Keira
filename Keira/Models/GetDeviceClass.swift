//
//  GetDeviceClass.swift
//  Keira
//
//  Created by Matoi on 10.12.2023.
//
import UIKit

final class Device {
    static func get() -> UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
    }
    static func set(padnmac arg1: CGFloat, phone arg2: CGFloat) -> CGFloat {
        return self.get() == .pad ? arg1 : arg2
    }
}
