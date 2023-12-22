//
//  BTDeviceServiceManager.swift
//  Keira
//
//  Created by Matoi on 22.12.2023.
//

import SwiftUI
import CoreBluetooth

enum __characteristic_type {
    case message, leftJoysick, rightJoystick
}

class BTDeviceServiceManager {
    
    var peripheral: CBPeripheral? = nil
    var service: CBService? = nil
    
    var msgCharacteristic: CBCharacteristic? = nil
    var leftJoystickCharacteristic: CBCharacteristic? = nil
    var rightJoystickCharacteristic: CBCharacteristic? = nil
    
    func eraseAll() -> Void {
        self.peripheral = nil
        self.service = nil
        self.msgCharacteristic = nil
        self.leftJoystickCharacteristic = nil
        self.rightJoystickCharacteristic = nil
    }
    
}
