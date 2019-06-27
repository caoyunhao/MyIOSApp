//
//  UIView+.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/30.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

extension UIView {
    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        self.addGestureRecognizer(gr)
    }
    
    func addSwipeUp(target: AnyObject, action: Selector) {
        let gr = UISwipeGestureRecognizer(target: target, action: action)
        gr.direction = .up
        isUserInteractionEnabled = true
        self.addGestureRecognizer(gr)
    }
    
    func addSwipeDown(target: AnyObject, action: Selector) {
        let gr = UISwipeGestureRecognizer(target: target, action: action)
        gr.direction = .down
        isUserInteractionEnabled = true
        self.addGestureRecognizer(gr)
    }
    
    func cornersRadius(byRoundingCorners: UIRectCorner, cornerRadii: CGSize) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: byRoundingCorners, cornerRadii: cornerRadii).cgPath
        layer.mask = maskLayer
    }
    
    var safeAreaFrame: CGRect {
        let insets = safeAreaInsets
        
        let rect = CGRect(x: frame.origin.x + insets.left, y: frame.origin.y + insets.top, width: frame.size.width - insets.left - insets.right, height: frame.size.height - insets.top - insets.bottom)
        
        return rect
    }
}
