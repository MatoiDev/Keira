//
//  GearboxView.swift
//  Keira
//
//  Created by Matoi on 12.02.2024.
//

import SwiftUI

final class GearBoxViewController: ObservableObject {
    
    @Published var sliderPosition = CGPoint(x: 180, y: 180)
    
    // MARK: - Change position
    func handlePath(_ location: CGPoint) -> Void {
        let x = self.setCorrectXPosition(location.x)
        let y = self.setCorrectYPosition(points: CGPoint(x: x, y: location.y))
        
        self.sliderPosition = CGPoint(x: x, y: y)
    }
    
    private func canShiftGear(_ x: CGFloat) -> Bool {
        return (x <= 100.0) || (160.0...200.0 ~= x) || (x >= 260.0)
    }
    
    private func setCorrectXPosition(_ x: CGFloat) -> CGFloat {
        return min(max(x, 80.0), 280.0)
    }
    
    private func setCorrectYPosition(points: CGPoint) -> CGFloat {
        let x: CGFloat = points.x
        let y: CGFloat = points.y
        
        if (canShiftGear(x)) {
            return min(max(y, 60.0), 300.0)
        }
        return 180.0
    }
    
    // MARK: - Ended
    func handleEnded(_ location: CGPoint) -> Void {
        print(location.x, location.y)
        var y = self.setCorrectYPositionOnEnded(points: location)
        var x = self.setCorrectXPositionOnEnded(points: location)
        print(x, y)
        if (x == 80.0 && y == 180.0) || (x == 280.0 && y == 180.0) {
            x = 180.0
            y = 180.0
        }

        self.sliderPosition = CGPoint(x: x, y: y)
    }
    
    private func setCorrectXPositionOnEnded(points: CGPoint) -> CGFloat {
        if (points.y < 120.0 || points.y > 240.0) {
            if (...100 ~= points.x) {
                Vibro.trigger(.success)
                return 80.0
            }
            if (160...200 ~= points.x) {
                Vibro.trigger(.success)
                return 180.0
            }
            if (260... ~= points.x) {
                Vibro.trigger(.success)
                return 280.0
            }
        }
        Vibro.trigger(.warning)
        return 180.0
        
        
    }
    
    private func setCorrectYPositionOnEnded(points: CGPoint) -> CGFloat {
        if (points.y < 100.0) { return 60.0 }
        if (points.y > 260.0) { return  300.0 }
        return 180.0
    }
    
}

enum ShiftedGear: Int {
    case reverse = -1,
         neutral = 0,
         first = 1,
         second = 2,
         third = 3,
         fourth = 4,
         fifth = 5
}

struct GearboxView: View {
    
    @StateObject private var _vm: GearBoxViewController = GearBoxViewController()
    @Binding var shiftedGear: ShiftedGear
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 360, height: 360)
                .foregroundColor(.clear)
                .overlay(alignment: .center, content: {
                    Image("transmission")
                        .resizable()
                        .frame(width: 360, height: 360)
                        .scaledToFit()
                        .offset(x:19, y: 12)
                })
                .overlay {
                   GearboxKnob()
                        .position(_vm.sliderPosition)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self._vm.handlePath(value.location)
                                }
                                .onEnded { value in
                                    self._vm.handleEnded(value.location)
                                    switch value.location {
                                    case CGPoint(x: 80.0, y: 60.0):
                                        self.shiftedGear = .first
                                    case CGPoint(x: 80.0, y: 300.0):
                                        self.shiftedGear = .second
                                    case CGPoint(x: 180.0, y: 60.0):
                                        self.shiftedGear = .third
                                    case CGPoint(x: 180.0, y: 300.0):
                                        self.shiftedGear = .fourth
                                    case CGPoint(x: 280.0, y: 60.0):
                                        self.shiftedGear = .fifth
                                    case CGPoint(x: 280.0, y: 300.0):
                                        self.shiftedGear = .reverse
                                    default:
                                        self.shiftedGear = .neutral
                                    }
                                }
                        )
                }
            
        
        }
    }
}

struct GearboxView_Previews: PreviewProvider {
    static var previews: some View {
        GearboxView(shiftedGear: .constant(.neutral))
            .previewLayout(.sizeThatFits)
    }
}
