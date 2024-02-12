//
//  PopupModeCell.swift
//  Keira
//
//  Created by Matoi on 24.01.2024.
//

import SwiftUI

enum PopupMode {
    case joysticks, real
}

struct PopupModeTip: View {
    
    private let image: Image
    private let text: String
    private let rotationDegrees: CGFloat
    
    init(image: Image, text: String, rotationDegrees: CGFloat=0.0) {
        self.image = image
        self.text = text
        self.rotationDegrees = rotationDegrees
    }
    
    var body: some View {
        VStack {
            self.image
                .resizable()
                .renderingMode(.template)
                .symbolRenderingMode(.hierarchical)
                .scaledToFit()
                .frame(width: 30, height: 30)
                .rotationEffect(Angle(degrees: self.rotationDegrees))
                .foregroundColor(.white)
            Text(self.text)
                .ralewayFont(.medium, 10, color: .white)
        }
    }
    
}

//#colorLiteral(red: 0.2675397396, green: 0.2625786066, blue: 0.2669721246, alpha: 1)

struct PopupModeCell: View {
    
    private let mode: PopupMode
    
    init(withMode mode: PopupMode) {
        self.mode = mode
    }
    
    var body: some View {
        NavigationLink(destination: self.mode == .real ? AnyView(RealControlPadMainView()) : AnyView(ClassicControlPadMainView()))
        {
            
            VStack(alignment: .center) {
                VStack (alignment: .center) {
                    Text(self.mode == .real ? "Real mode" : "Classic mode")
                        .ralewayFont(.bold, 22, color: .white).padding(.bottom, 1)
                    Text(self.mode == .real ? "Control the **steering**, shift the **gearbox** just like in a real car" : "Use the **joysticks** or **keyboard** to control your car")
                        .ralewayFont(.medium, 15, color: .gray)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 16)

                HStack(alignment: .center, spacing: 16) {
                    
                    PopupModeTip(image: Image( "iphone.gen2.landscape"), text: "iPhone")
                    PopupModeTip(image: Image(systemName: "laptopcomputer"), text: "Macbook")
                    
                    if self.mode == .real {
                        PopupModeTip(image: Image("transmission"), text: "Gearbox")
                    } else {
                        PopupModeTip(image: Image(systemName: "keyboard"), text: "Keyboard")
                    }
                    if self.mode == .real {
                        PopupModeTip(image: Image("steering_wheel"), text: "Steering", rotationDegrees: -45.0)
                    } else {
                        PopupModeTip(image: Image(systemName: "r.joystick.fill").symbolRenderingMode(.palette), text: "Joystick")
                    }
                    
                }
                
            }.padding(.vertical, 8)
                .background(Color(uiColor: #colorLiteral(red: 0.1498875022, green: 0.1449306607, blue: 0.1450200379, alpha: 0.8984023086)))
                .mask {
                    RoundedRectangle(cornerRadius: 28)
                }
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth:.infinity, maxHeight: 150)
        
    }
}

struct PopupModeCell_Previews: PreviewProvider {
    static var previews: some View {
        PopupModeCell(withMode: .real)
    }
}
