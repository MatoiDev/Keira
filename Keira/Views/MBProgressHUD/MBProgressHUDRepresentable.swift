//
//  MBProgressHUDRepresentable.swift
//  Coda
//
//  Created by Matoi on 18.02.2023.
//

import SwiftUI

struct MBProgressHUDRepresentable: UIViewControllerRepresentable {
    
    @Binding var percent: Double
    @Binding var show: Bool
    
    let completion: () -> ()
    
    init(percent: Binding<Double>, show: Binding<Bool>, completion: @escaping () -> ()) {
        self._percent = percent
        self._show = show
        self.completion = completion
    }
    
    private var progressHud: Progress = Progress(totalUnitCount: 100)
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let hud = MBProgressHUD.showAdded(to: viewController.view, animated: true)
        hud.removeFromSuperViewOnHide = true
        
        self.progressHud.completedUnitCount = 0
        hud.mode = .annularDeterminate
        hud.tintColor = UIColor.systemOrange
        hud.progressObject = self.progressHud
        
        return viewController
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    
        guard !(self.percent.isNaN || self.percent.isInfinite) else {
            return 
        }
        if let hud = MBProgressHUD.forView(uiViewController.view) {
            hud.progressObject = self.progressHud
            hud.removeFromSuperViewOnHide = true
            DispatchQueue.main.async {
                
                    let roundedPercent = Int64(self.percent)
                    self.progressHud.completedUnitCount = roundedPercent

                    if self.progressHud.completedUnitCount == 100 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                            
                            withAnimation {
                                let image: UIImage = UIImage(systemName: "checkmark")!
                            
                                hud.mode = .customView
                                hud.customView = UIImageView(image: image.withTintColor(UIColor.systemOrange))
                                
                            }
                            self.completion()
                            hud.hide(animated: true, afterDelay: 1)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.show = false
                            }
                            

                            
                        }
                    } else if self.progressHud.completedUnitCount == -1 {
                        
                        withAnimation {
                            let image: UIImage = UIImage(systemName: "xmark")!
                        
                            hud.mode = .customView
                            hud.customView = UIImageView(image: image.withTintColor(UIColor.systemOrange))
                            
                        }
                        hud.hide(animated: true, afterDelay: 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.show = false
                        }
                    }
                
                
            }
        }
    }
}


