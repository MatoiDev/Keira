//
//  ControlPadMainViewModel.swift
//  Keira
//
//  Created by Matoi on 23.12.2023.
//

import Combine
import SwiftUI

class ControlPadMainViewModel {
    
    private var cancellables: Set<AnyCancellable> = []
    private let updateInterval: TimeInterval = 0.1
    
    enum Side {
        case right, left
    }
    
    private var lastUpdateTime: Date = Date()
    
    func convert(coordinates: CGPoint, vm: BTDevicesViewModel, side: ControlPadMainViewModel.Side) {
        let currentTime = Date()
        
        
        
        if currentTime.timeIntervalSince(lastUpdateTime) >= updateInterval || coordinates.x == -100 || coordinates.x == 100 || coordinates.y == 100 || coordinates.y == -100 || coordinates == .zero  {
            
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
