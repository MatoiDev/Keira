//
//  Vibro.swift
//  Keira
//
//  Created by Matoi on 15.12.2023.
//

import SwiftUI
import CoreHaptics

class Vibro {
    
    static let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
    
    static func prepareEngine(engine: inout CHHapticEngine?/*,  completion: @escaping (Result<String, Error>) -> Void*/) -> Void {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Cannot creat an engine: \(error.localizedDescription )")
        }
    }
    
    /// Simple haptics.
    static func trigger(_ notif: UINotificationFeedbackGenerator.FeedbackType) -> Void {
        self.generator.notificationOccurred(notif)
    }
    
    
    /// More complex haptics.
    /// - Warning: Need an engine
    /// - Parameter engine: Haptics engine
    /// - Returns: Nothing
    static func complexSuccess(engine: CHHapticEngine?) -> Void {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events : [CHHapticEvent] = []
        
        let intensety: CHHapticEventParameter = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness: CHHapticEventParameter = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensety, sharpness], relativeTime: 0)
        events.append(event)
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern \(error.localizedDescription)")
        }
    }
}
