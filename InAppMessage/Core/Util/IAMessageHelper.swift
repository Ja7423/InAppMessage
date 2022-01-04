//
//  IAMessageHelper.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/22.
//

import Foundation
import UIKit

extension UIApplication {
    var activeWindow: UIWindow? {
        var activeWindow: UIWindow?
        for window in windows {
            if let windowScene = window.windowScene,
               windowScene.activationState == .foregroundActive,
               window.isKeyWindow {
                activeWindow = window
                break
            }
        }
        
        return activeWindow
    }
    
    var safeAreaInsets: UIEdgeInsets {
        return activeWindow?.safeAreaInsets ?? .zero
    }
}
