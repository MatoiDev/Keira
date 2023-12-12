//
//  BTDeviceCell.swift
//  Keira
//
//  Created by Matoi on 06.12.2023.
//

import SwiftUI
import CoreBluetooth



struct BTDeviceCell: View {
    
    @EnvironmentObject var btVM: BTDevicesViewModel
    
    private let peripheral: CBPeripheral
    
    init(with peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
    
    private var humanReadConnectionStatus: String {
        guard let device = self.btVM.selectedDevice, device == peripheral else {return "Not connected"}
        switch self.btVM.selectedDevice?.state.rawValue{
        case 0:
            return "Not connected"
        case 1:
            return "Connecting"
        case 2:
            return "Connected"
        case 3:
            return "Error"
        default:
            return "Not connected"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(peripheral.name ?? "Unnamed device")
                    .ralewayFont(.medium, 17.0, color: .white)
                Text(humanReadConnectionStatus)
                    .ralewayFont(.regular, 16.0, color: .gray)
            }
            Spacer()

            if let peripheral = self.btVM.selectedDevice, peripheral == self.peripheral, self.btVM.deviceConnectionStatus == .connecting {
                ProgressView()
                Button {
                    self.btVM.dropDevice(peripheral)
                    self.btVM.selectedDevice = nil
                    self.btVM.deviceConnectionStatus = .disconnected
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: Device.set(padnmac: 32.0, phone: 16.0), height: Device.set(padnmac: 32.0, phone: 16.0))
                        .foregroundColor(.red)
                }.padding(.leading)

            }
            else if let peripheral = self.btVM.selectedDevice, peripheral == self.peripheral, self.btVM.deviceConnectionStatus == .connected {
                Button {
                    self.btVM.dropDevice(peripheral)
                    self.btVM.selectedDevice = nil
                    self.btVM.deviceConnectionStatus = .disconnected
                } label: {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: Device.set(padnmac: 32.0, phone: 16.0), height: Device.set(padnmac: 32.0, phone: 16.0))
                        .foregroundColor(.green)
                }
             
            }
            else if let peripheral = self.btVM.selectedDevice, peripheral == self.peripheral, self.btVM.deviceConnectionStatus == .error {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: Device.set(padnmac: 32.0, phone: 16.0), height: Device.set(padnmac: 32.0, phone: 16.0))
                    .foregroundColor(.red)
            } else {
                Button{
                    if let device = self.btVM.selectedDevice, device == self.peripheral {return}
                    self.btVM.stopScan()
                    self.btVM.dropDevice(self.btVM.selectedDevice) // Disconnect before new connection
                    self.btVM.selectedDevice = self.peripheral
                    self.btVM.connectToRobot()
                    print("Selected device: \(self.peripheral.name ?? "Unnamed")")
                } label: {
                    Text("Connect")
                        .padding(2)
                        .padding(.horizontal, 1)
                        .overlay(RoundedRectangle(cornerRadius: 4.0).stroke(self.btVM.deviceConnectionStatus == .connecting ? Color.gray : Color.blue, lineWidth: 1))
                        .ralewayFont(.regular, 14.0, color: self.btVM.deviceConnectionStatus == .connecting ? Color.gray : Color.blue)
                }.disabled(self.btVM.deviceConnectionStatus == .connecting)
            }
          
        }
        
    }
}

