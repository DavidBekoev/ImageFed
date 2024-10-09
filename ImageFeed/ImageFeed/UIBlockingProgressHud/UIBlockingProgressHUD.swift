//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 09.09.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animationType = .circleArcDotSpin
        ProgressHUD.colorAnimation = .black
        ProgressHUD.animate()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    } 
    
}
