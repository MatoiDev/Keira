//
//  MainPickerCell.swift
//  Keira
//
//  Created by Matoi on 06.12.2023.
//

import SwiftUI

enum MainPickerCellType {
    case forRobot
    case forCamera
}

struct MainPickerCell: View {
    
    @EnvironmentObject var btVM: BTDevicesViewModel
    
    private let type: MainPickerCellType
    
    init(withType type: MainPickerCellType) {
        self.type = type
    }
    
    var cellColor: Color {
        get {

            switch self.btVM.deviceConnectionStatus {
            case .connected:
                return Color.green
            case .connecting:
                return Color.yellow
            case .error:
                return Color.red
            default:
                return Color.black
            }

        }
    }
    
    var body: some View {
  
        HStack(alignment: .center) {
            Image(self.type == .forRobot ? "Robot" : "Camera")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(self.cellColor == .black ? .orange : self.cellColor)
                    .scaledToFit()
                    .frame(width: Device.set(padnmac: 150, phone: 70), height: Device.set(padnmac: 150, phone: 70))
            
                VStack(alignment: .leading) {
                    HStack {
                        Text(self.type == .forRobot ? "Your robot" : "Your camera")
                            .ralewayFont(.semibold, Device.set(padnmac: 30, phone: 15), color: .white)
                        if self.type == .forCamera {
                            Text("Optional")
                                .ralewayFont(.light, Device.set(padnmac: 28, phone: 14), color: .secondary)
                        }
                        
                    }
                    
                    Text(self.type == .forRobot ?
                            self.cellColor == .black ?
                                "Select the device you want to control"
                            : self.btVM.selectedDevice?.name ?? "Unnamed device"
                         :  self.cellColor == .black ?
                                "Select a camera to control your robot in FPV mode"
                            : self.btVM.selectedCamera?.name ?? "Unnamed Camera")
                    .ralewayFont(.regular, Device.set(padnmac: 32, phone: 16), color: .secondary)
                }
            if self.type == .forRobot, self.btVM.deviceConnectionStatus == .connecting {
                Spacer()
                ProgressView()
                    .frame(width: Device.set(padnmac: 50.0, phone: 16.0), height: Device.set(padnmac: 50.0, phone: 16.0))
            } else if self.type == .forCamera, self.btVM.cameraConnectionStatus == .connecting {
                Spacer()
                ProgressView()
                    .frame(width: Device.set(padnmac: 50.0, phone: 16.0), height: Device.set(padnmac: 50.0, phone: 16.0))
            } else {
                EmptyView()
            }
            

        }
        .frame(height: Device.set(padnmac: 175, phone: 100))

        
    }
}

struct MainPickerCell_Previews: PreviewProvider {
    static var previews: some View {
        MainPickerCell(withType: .forCamera)
    }
}
