//
//  BTDevicesViewModel.swift
//  Keira
//
//  Created by Matoi on 06.12.2023.
//

import SwiftUI
import CoreBluetooth
import Combine

enum ConnectionStatus {
    case connected // Green
    case disconnected // Black
    case scanning // Black
    case connecting // Yellow
    case error // Red
}

enum BTDevicesReloadingState {
    case reloading
    case reloaded
}

enum DeviceUUIDs: String {
    case __SERVICE_UUID = "9A8CA9EF-E43F-4157-9FEE-C37A3D7DC12D"
    case __CHARACTERISTIC_UUID = "CC46B944-003E-42B6-B836-C4246B8F19A0"
    case __LEFT_JOYSTICK_CHARACTERISTIC_UUID = "F2B9C6E1-4F9E-4E71-BB3C-7A3B6F8C0A8A"
    case __RIGHT_JOYSTICK_CHARACTERISTIC_UUID = "A8D6F7C4-9E3B-4B6E-8E9F-1E6C8B9A0D2D"
}

final class BTDevicesViewModel: NSObject, ObservableObject {
    
    private var connectTimer: AnyCancellable?
    private var reloadTimer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    private var centralManager: CBCentralManager?
    
    @Published var peripherals: [CBPeripheral] = []
    @Published var devicesReloadingState: BTDevicesReloadingState = .reloading
    
    // For robot
    @Published var selectedDevice: CBPeripheral? = nil
    @Published var deviceConnectionStatus: ConnectionStatus = .disconnected
    
    // For camera
    @Published var selectedCamera: CBPeripheral? = nil
    @Published var cameraConnectionStatus: ConnectionStatus = .disconnected
    
    private var serviceManager: BTDeviceServiceManager = BTDeviceServiceManager()
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func connectToRobot() {
        if let peripheral = self.selectedDevice {
            self.deviceConnectionStatus = .connecting
              self.centralManager?.connect(peripheral)

              connectTimer = Timer.publish(every: 10, on: .main, in: .default)
                  .autoconnect()
                  .sink(receiveValue: { _ in
                      if self.deviceConnectionStatus == .connecting {
                          self.centralManager?.cancelPeripheralConnection(peripheral)
                          self.deviceConnectionStatus = .error
                          self.connectTimer?.cancel()
                      }
                  })

        
            self.$deviceConnectionStatus
                  .sink(receiveValue: { status in
                      if status == .connected {
                          self.connectTimer?.cancel()
                      }
                  })
                  .store(in: &cancellables)
        }
      }
    
    func stopScan() {
        self.centralManager?.stopScan()
        self.devicesReloadingState = .reloaded
        self.reloadTimer?.cancel()
    }
    
    func reloadDevices() {
        
        self.centralManager?.scanForPeripherals(withServices: nil)
        self.devicesReloadingState = .reloading
        self.reloadTimer = Timer.publish(every: 5, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { _ in
                self.centralManager?.stopScan()
                self.devicesReloadingState = .reloaded
                self.reloadTimer?.cancel()
            })
    }
    
    func dropDevice(_ peripheral: CBPeripheral?) -> Void {
        guard let peripheral = peripheral else {return}
        self.centralManager?.cancelPeripheralConnection(peripheral)
    }
    
    func sendMessage(msg: String) -> Void {
        guard
            let peripheral = selectedDevice,
            let characteristic = self.serviceManager.msgCharacteristic
        else { return }
        
        if let data = msg.data(using: .utf8) {
            peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
            print("Send message over Bluetooth: \(data)")
        }
       
    }
    
    func updateLeftJoystickValue(x: UInt8, y: UInt8) -> Void {
        guard
            let peripheral = selectedDevice,
            let characteristic = self.serviceManager.leftJoystickCharacteristic
        else { return }
        
        if let data = "\(x) \(y)".data(using: .utf8) {
            peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
            print("Send left joystick value over Bluetooth: \(data)")
        }
    }
    
    func updateRightJoystickValue(x: UInt8, y: UInt8) -> Void {
        guard
            let peripheral = selectedDevice,
            let characteristic = self.serviceManager.rightJoystickCharacteristic
        else { return }
        
        if let data = "\(x) \(y)".data(using: .utf8) {
            peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
            print("Send right joystick value over Bluetooth: \(data)")
        }
    }
}

extension BTDevicesViewModel: CBPeripheralDelegate {}

extension BTDevicesViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.reloadDevices()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral), peripheral.name != nil {
            self.peripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        if let robotPeripheral = self.selectedDevice, robotPeripheral == peripheral {
            self.deviceConnectionStatus = .connected
        } else if let cameraPeripheral = self.selectedCamera, cameraPeripheral == peripheral {
            self.cameraConnectionStatus = .connected
        }
        
        print("Device connected")
        peripheral.delegate = self
        self.serviceManager.peripheral = peripheral
        peripheral.discoverServices([]) // Discover Service to controll ESP
        
       
    }
    
    private func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        
        if let robotPeripheral = self.selectedDevice, robotPeripheral == peripheral {
            self.selectedDevice = nil
            self.deviceConnectionStatus = .disconnected
        } else if let cameraPeripheral = self.selectedCamera, cameraPeripheral == peripheral {
            self.selectedCamera = nil
            self.cameraConnectionStatus = .disconnected
        }
        self.serviceManager.eraseAll()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let _ = error { return }
        
        guard let services = peripheral.services else { return }
    
        for service in services {
            if service.uuid.uuidString == DeviceUUIDs.__SERVICE_UUID.rawValue {
                self.serviceManager.service = service
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let _ = error { return }
        guard let characteristics: [CBCharacteristic] = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid.uuidString == DeviceUUIDs.__CHARACTERISTIC_UUID.rawValue {
                self.serviceManager.msgCharacteristic = characteristic
            }
            else if characteristic.uuid.uuidString == DeviceUUIDs.__LEFT_JOYSTICK_CHARACTERISTIC_UUID.rawValue {
                self.serviceManager.leftJoystickCharacteristic = characteristic
            }
            else if characteristic.uuid.uuidString == DeviceUUIDs.__RIGHT_JOYSTICK_CHARACTERISTIC_UUID.rawValue {
                self.serviceManager.rightJoystickCharacteristic = characteristic
            }
        }
        
    }

}
