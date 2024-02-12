//
//  GearboxKnob.swift
//  Keira
//
//  Created by Matoi on 12.02.2024.
//

import SwiftUI

struct GearboxKnob: View {
    var body: some View {
        Circle()
            .overlay(content: {
                Circle()
                    .stroke(lineWidth: 4)
                    .foregroundColor(.white)
                   
            })
            .frame(width: 50, height: 50)
            .foregroundColor(.gray)
    }
}

struct GearboxKnob_Previews: PreviewProvider {
    static var previews: some View {
        GearboxKnob()
    }
}
