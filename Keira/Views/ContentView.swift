//
//  ContentView.swift
//  Keira
//
//  Created by Matoi on 05.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            StarterView()
            PopupView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
