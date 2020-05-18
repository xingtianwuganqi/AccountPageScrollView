//
//  UIDeviceExtension.swift
//  App-720yun
//
//  Created by jingjun on 2018/5/30.
//  Copyright © 2018年 720yun. All rights reserved.
//

import UIKit

extension UIDevice {
    
    public func isX() -> Bool {
        
        if UIApplication.shared.statusBarOrientation.isPortrait && UIScreen.main.bounds.height == 812 {
            return true
        }else if UIApplication.shared.statusBarOrientation.isLandscape && UIScreen.main.bounds.width == 812 {
            return true
        }else if UIApplication.shared.statusBarOrientation.isLandscape && UIScreen.main.bounds.width == 896 {
            return true
        }

        return false
        
    }
    
}
