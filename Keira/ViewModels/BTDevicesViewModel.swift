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
                          print("Discard timer")
                          self.centralManager?.cancelPeripheralConnection(peripheral)
                          self.deviceConnectionStatus = .error
                          self.connectTimer?.cancel()
                      }
                  })

        
            self.$deviceConnectionStatus
                  .sink(receiveValue: { status in
                      if status == .connected {
                          print("Выключаю таймер, так как всё пожключили")
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
    
    func dropDevice(_ peripheral: CBPeripheral?) {
        guard let peripheral = peripheral else {return}
        self.centralManager?.cancelPeripheralConnection(peripheral)
    }
}

extension BTDevicesViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.reloadDevices()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let robotPeripheral = self.selectedDevice, robotPeripheral == peripheral {
            self.deviceConnectionStatus = .connected
        } else if let cameraPeripheral = self.selectedCamera, cameraPeripheral == peripheral {
            self.cameraConnectionStatus = .connected
        }
       
    }
    
    private func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        
        if let robotPeripheral = self.selectedDevice, robotPeripheral == peripheral {
            self.selectedDevice = nil
            self.deviceConnectionStatus = .disconnected
            print("Отключаюсь от робота \(peripheral.name ?? "Unnamed")")
        } else if let cameraPeripheral = self.selectedCamera, cameraPeripheral == peripheral {
            self.selectedCamera = nil
            self.cameraConnectionStatus = .disconnected
        }
        
    
        
    }
}
