//
//  SteeringView.swift
//  Keira
//
//  Created by Matoi on 12.02.2024.
//

import SwiftUI

final class SteeringViewModel: ObservableObject {
    
}



struct SteeringView: View {
    // Свойство для хранения начального положения руля
    @State private var initialAngle: Double = 0.0
    
    var body: some View {
        ZStack {
//            Color.gray.ignoresSafeArea()
            Image("steering_wheel")
                .resizable()
                .frame(width: 100, height: 100)
                .rotationEffect(Angle.degrees(initialAngle))
                .gesture(DragGesture()
                    .onChanged { value in
                        // Определяем угол поворота
                        let vector = CGVector(dx: value.location.x - value.startLocation.x,
                                              dy: value.location.y - value.startLocation.y)
                        let angle = atan2(vector.dy, vector.dx)
                        
                        // Преобразуем радианы в градусы
                        let angleDegrees = angle * 180 / .pi
                        
                        // Ограничиваем угол поворота от -180 до 180 градусов
                        let clampedAngle = max(-180.0, min(180.0, angleDegrees))
                        
                        // Применяем поворот
                        self.initialAngle = clampedAngle
                    }
                    .onEnded { _ in
                        // Возвращаем руль в начальное положение
                        withAnimation {
                            self.initialAngle = 0.0
                        }
                    }
                )
        }
    }
}

struct SteeringView_Previews: PreviewProvider {
    static var previews: some View {
        SteeringView()
    }
}
