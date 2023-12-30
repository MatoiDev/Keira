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
    case succes, failed, loadControl, none
}

final class PopupViewModel: ObservableObject {
    
    @Published var isPresented: Bool = false
    @Published var popupCase: PopupCase = .none
    
    // For fullcover mode
    @Published var percentages: Double = 0.0
    
    private var timerCancellable: AnyCancellable?
    private var engine: CHHapticEngine?
    
    init() {
        Vibro.prepareEngine(engine: &self.engine)
    }
    
    func showPopup() -> Void {
        if self.popupCase != .loadControl {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                self.isPresented = false
            }
        }
       
        
        withAnimation {
            self.timerCancellable?.cancel()
        }
        
        if self.popupCase == .loadControl {
            self.isPresented = true
            DispatchQueue.main.async {
                self.percentages = 20.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                self.percentages = 83.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
                self.percentages = 100.0
            }
           
            
        } else {
            withAnimation(Animation.spring()) {
                self.isPresented = true
                if self.popupCase == .succes {
                    Vibro.trigger(.success)
                } else if self.popupCase == .failed {
                    Vibro.trigger(.error)
                }
            }
        }

        
        timerCancellable = Timer.publish(every: 3.0, on: .main, in: .default).autoconnect().sink { _ in
            withAnimation(Animation.easeInOut(duration: 0.8)) {
                self.isPresented = false
            }
            self.timerCancellable?.cancel()
        }
    }
}
