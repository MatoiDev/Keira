//
//  PopupView.swift
//  Keira
//
//  Created by Matoi on 15.12.2023.
//

import SwiftUI


struct PopupView: View {
    
    @EnvironmentObject var popupVM: PopupViewModel
    
    var body: some View {
        if popupVM.isPresented {
            HStack {
                Image(systemName: popupVM.popupCase == .succes ? "antenna.radiowaves.left.and.right" : "antenna.radiowaves.left.and.right.slash")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 36)
                    .foregroundColor(popupVM.popupCase == .succes ? .green : .red)
                Text(popupVM.popupCase == .succes ? "Connection succeeded!" : "Connection failed")
                    .ralewayFont(.bold, 17.0, color: .white).padding(.leading, 5)
                Spacer()
            }.padding()
            .frame(maxWidth: .infinity, maxHeight: 64.0)

            .background((self.popupVM.popupCase == .succes ? Color.green : Color.red).opacity(0.2))
            .backgroundBlur(radius: 10, opaque: true) // More Elegant than material
            .cornerRadius(18.0)
            .padding()
            .frame(maxHeight: .infinity, alignment: .bottom)
            .transition(.move(edge: .bottom))
        }
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView()
    }
}
