//
//  PopupViewModel.swift
//  Keira
//
//  Created by Matoi on 16.12.2023.
//

import SwiftUI
import Combine
import CoreHaptics

enum PopupCase {
    case succes, failed, none
}

final class PopupViewModel: ObservableObject {
    
    @Published var isPresented: Bool = false
    @Published var popupCase: PopupCase = .none
    
    private var timerCancellable: AnyCancellable?
    private var engine: CHHapticEngine?
    
    init() {
        Vibro.prepareEngine(engine: &self.engine)
    }
    
    func showPopup() -> Void {
        withAnimation {
            self.timerCancellable?.cancel()
        }
        
        
        withAnimation(Animation.spring()) {
            self.isPresented = true
            if self.popupCase == .succes {
                Vibro.trigger(.success)
            } else {
                Vibro.trigger(.error)
            }
        }
        
        timerCancellable = Timer.publish(every: 3.0, on: .main, in: .default).autoconnect().sink { _ in
            withAnimation(Animation.spring()) {
                self.isPresented = false
            }
            
            self.timerCancellable?.cancel()
        }
    }
    
}
