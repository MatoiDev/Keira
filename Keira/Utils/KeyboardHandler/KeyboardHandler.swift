import UIKit
import SwiftUI

class UIExternalKeyboardHandler: UIViewController {
    
    @Binding var leftJoystick: CGPoint
    @Binding var rightJoystick: CGPoint
    
    init(leftJS: Binding<CGPoint>, rightJS: Binding<CGPoint>) {
        self._leftJoystick = leftJS
        self._rightJoystick = rightJS
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        
        var didHandleEvent = false
        for press in presses {
            guard let key = press.key else { continue }
            switch key.charactersIgnoringModifiers {
                // Handle Right Joystick
                case UIKeyCommand.inputUpArrow:
                    print("RJ_FORWARD \(rightJoystick.y)")
                    rightJoystick.y -= 100.0
                    didHandleEvent = true
                case UIKeyCommand.inputDownArrow:
                    print("RJ_BACKWARD")
                    rightJoystick.y += 100.0
                    didHandleEvent = true
                case UIKeyCommand.inputRightArrow:
                    print("RJ_RIGHT")
                    rightJoystick.x += 100.0
                    didHandleEvent = true
                case UIKeyCommand.inputLeftArrow:
                    print("RJ_LEFT")
                    rightJoystick.x -= 100.0
                    didHandleEvent = true
                
                // Handle Left Joystick
                case "w":
                    print("LJ_FORWARD")
                    leftJoystick.y -= 100.0
                    didHandleEvent = true
                case "s":
                    print("LJ_BACKWARD")
                    leftJoystick.y += 100.0
                    didHandleEvent = true
                case "d":
                    print("LJ_RIGHT")
                    leftJoystick.x += 100.0
                    didHandleEvent = true
                case "a":
                    print("LJ_LEFT")
                    leftJoystick.x -= 100.0
                    didHandleEvent = true
                default:
                    didHandleEvent = true
            }
        }
        
        if didHandleEvent == false {
            super.pressesBegan(presses, with: event)
        }
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {

        var didHandleEvent = false
        for press in presses {
            guard let key = press.key else { continue }
            switch key.charactersIgnoringModifiers {
            // Handle Right Joystick
            case UIKeyCommand.inputUpArrow:
                print("RJ_FORWARD")
                rightJoystick.y += 100.0
                didHandleEvent = true
            case UIKeyCommand.inputDownArrow:
                print("RJ_BACKWARD")
                rightJoystick.y -= 100.0
                didHandleEvent = true
            case UIKeyCommand.inputRightArrow:
                print("RJ_RIGHT")
                rightJoystick.x -= 100.0
                didHandleEvent = true
            case UIKeyCommand.inputLeftArrow:
                print("RJ_LEFT")
                rightJoystick.x += 100.0
                didHandleEvent = true
            
            // Handle Left Joystick
            case "w":
                print("LJ_FORWARD")
                leftJoystick.y += 100.0
                didHandleEvent = true
            case "s":
                print("LJ_BACKWARD")
                leftJoystick.y -= 100.0
                didHandleEvent = true
            case "d":
                print("LJ_RIGHT")
                leftJoystick.x -= 100.0
                didHandleEvent = true
            case "a":
                print("LJ_LEFT")
                leftJoystick.x += 100.0
                didHandleEvent = true
            default:
                didHandleEvent = true
            }
        }
        
        if didHandleEvent == false {
            super.pressesBegan(presses, with: event)
        }
    }
}

struct UIExternalKeyboardHandlerRepresentable: UIViewControllerRepresentable {

    @ObservedObject var leftJoystickMonitor : JoystickMonitor
    @ObservedObject var rightJoystickMonitor : JoystickMonitor
    
    init(leftJS: JoystickMonitor, rightJS: JoystickMonitor) {
        self._leftJoystickMonitor = ObservedObject(wrappedValue: leftJS)
        self._rightJoystickMonitor = ObservedObject(wrappedValue: rightJS)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        UIExternalKeyboardHandler(leftJS: self.$leftJoystickMonitor.xyPoint, rightJS: self.$rightJoystickMonitor.xyPoint)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    
    
    
}
