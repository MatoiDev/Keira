//
//  ModePopup.swift
//  Keira
//
//  Created by Matoi on 24.01.2024.
//

import SwiftUI

struct ModePopup: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        if self.isPresented {
            ZStack {
                Color.black.opacity(0.01).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        print("hgkjhg")
                        self.isPresented.toggle()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    .backgroundBlur()
                VStack(spacing: 16) {
                    PopupModeCell(withMode: .joysticks)
                      
                    PopupModeCell(withMode: .real)

                }
                .padding(24)
                .frame(maxWidth: 400)
                
                .background(RoundedRectangle(cornerRadius: 28)
                    .stroke(lineWidth: 3)
                    .foregroundColor(.orange)
                    .background(Color.black)
                   )
                .background(.thickMaterial)
                .mask {
                    RoundedRectangle(cornerRadius: 28)
                }
                .padding()
                
            }.transition(AnyTransition.scale.animation(.easeInOut(duration: 0.15)))

        }
   
    }
}

struct ModePopup_Previews: PreviewProvider {
    static var previews: some View {
        ModePopup(isPresented: .constant(true))
    }
}
