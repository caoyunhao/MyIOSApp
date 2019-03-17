//
//  LayoutHelper.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/29.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class ConstraintUtil {
    static func setWidth(_ view: UIView, _ width: CGFloat, where mainView: UIView? = nil) {
        (mainView ?? view).addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: width),
            ])
    }
    
    static func setHeight(_ view: UIView, _ height: CGFloat, where mainView: UIView? = nil) {
        (mainView ?? view).addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .height,
                               multiplier: 1.0,
                               constant: height),
            ])
    }
    
    static func alignCenterX(_ view: UIView, to toView: UIView) {
        toView.addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0),
            ])
    }
    
    static func alignCenterY(_ view: UIView, to toView: UIView, where mainView: UIView? = nil) {
        (mainView ?? toView).addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .centerY,
                               multiplier: 1.0,
                               constant: 0.0),
            ])
    }
    
    // 左最齐，offset向右为正
    static func alignLeft(_ view: UIView, to toView: UIView, where mainView: UIView? = nil,  offset: CGFloat = 0.0) {
        (mainView ?? toView).addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .left,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .left,
                               multiplier: 1.0,
                               constant: offset),
            ])
    }
    // 放置右边
    static func alignLeft(_ view: UIView, at toView: UIView, where mainView: UIView? = nil, offset: CGFloat = 0.0) {
        (mainView ?? toView).addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .right,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .left,
                               multiplier: 1.0,
                               constant: -offset),
            ])
    }
    
    // 右最齐，offset向左为正
    static func alignRight(_ view: UIView, to toView: UIView, where mainView: UIView? = nil, offset: CGFloat = 0.0) {
        (mainView ?? toView).addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .right,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .right,
                               multiplier: 1.0,
                               constant: -offset),
            ])
    }
    
    static func alignRight(_ view: UIView, at toView: UIView, where mainView: UIView? = nil, offset: CGFloat = 0.0) {
        (mainView ?? toView).addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .left,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .right,
                               multiplier: 1.0,
                               constant: offset),
            ])
    }
    
    static func align(_ belowView: UIView, below aboveView: UIView, where mainView: UIView? = nil, offset: CGFloat = 0.0) {
        (mainView ?? aboveView).addConstraints([
            NSLayoutConstraint(item: belowView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: aboveView,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: offset),
            ])
    }
    
    static func alignTop(_ view: UIView, to toView: UIView, offset: CGFloat = 0.0) {
        toView.addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: offset),
            ])
    }
    
    static func alignBottom(_ view: UIView, to toView: UIView, offset: CGFloat = 0.0) {
        toView.addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: -offset),
            ])
    }
    
    static func alignWidth(_ view: UIView, to toView: UIView) {
        toView.addConstraints([
            NSLayoutConstraint(item: view,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: view,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0),
            ])
    }
    
    static func alignCompletely(_ view: UIView, child childView: UIView) {
        view.addConstraints([
            NSLayoutConstraint(item: childView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: childView,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: childView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: childView,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0.0)
            ])
    }
    
    static func calulateWidth(_ view: UIView, where mainView: UIView, other count: Int) -> CGFloat {
        return (mainView.frame.size.width - view.frame.size.width) / CGFloat(count)
    }
}
