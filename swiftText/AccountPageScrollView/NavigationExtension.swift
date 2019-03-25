//
//  NavigationExtension.swift
//  App-720yun
//
//  Created by jingjun on 2018/5/18.
//  Copyright © 2018年 720yun. All rights reserved.
//

import UIKit

// MARK: - ⚠️方法一
extension UINavigationBar {
    // MARK: - RunTime
    private struct NavigationBarKeys {
        static var overlayKey = "overlayKey"
    }
    
    var overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &NavigationBarKeys.overlayKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &NavigationBarKeys.overlayKey, newValue as UIView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    // MARK: - 接口
    func Mg_setBackgroundColor(backgroundColor: UIColor) {
        if overlay == nil {
            self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            
            if UIDevice.current.isX() {
                overlay = UIView.init(frame: CGRect.init(x: 0, y: 0, width: bounds.width, height: bounds.height+40))
                
            }else {
                overlay = UIView.init(frame: CGRect.init(x: 0, y: 0, width: bounds.width, height: bounds.height+20))
                
            }
            overlay?.isUserInteractionEnabled = false
            overlay?.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        }
        overlay?.backgroundColor = backgroundColor
        subviews.first?.insertSubview(overlay!, at: 0)
    }
    
    
    func Mg_setTranslationY(translationY: CGFloat) {
        transform = CGAffineTransform.init(translationX: 0, y: translationY)
    }
    
    func Mg_setElementsAlpha(alpha: CGFloat) {
        for (_, element) in subviews.enumerated() {
            if element.isKind(of: NSClassFromString("UINavigationItemView") as! UIView.Type) ||
                element.isKind(of: NSClassFromString("UINavigationButton") as! UIButton.Type) ||
                element.isKind(of: NSClassFromString("UINavBarPrompt") as! UIView.Type)
            {
                element.alpha = alpha
            }
            
            if element.isKind(of: NSClassFromString("_UINavigationBarBackIndicatorView") as! UIView.Type) {
                element.alpha = element.alpha == 0 ? 0 : alpha
            }
        }
        
        items?.forEach({ (item) in
            if let titleView = item.titleView {
                titleView.alpha = alpha
            }
            for BBItems in [item.leftBarButtonItems, item.rightBarButtonItems] {
                BBItems?.forEach({ (barButtonItem) in
                    if let customView = barButtonItem.customView {
                        customView.alpha = alpha
                    }
                })
            }
        })
    }
    
    /// viewWillDisAppear调用
    func Mg_reset() {
        setBackgroundImage(nil, for: UIBarMetrics.default)
        overlay?.removeFromSuperview()
        overlay = nil
    }
}
