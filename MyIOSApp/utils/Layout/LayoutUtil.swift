//
//  SimpleLayout.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/29.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class LayoutUtil: NSObject {
    static func verticalCenterView(subViews: [UIView], at contentView: UIView, offset: CGFloat) {
        DLog(message: "subViews: \(subViews.count)")
        if subViews.count > 0 {
            var first = true
            var preView = subViews[0]
            for subView in subViews {
                subView.translatesAutoresizingMaskIntoConstraints = false
                ConstraintUtil.alignCenterX(subView, to: contentView)
                if first {
                    ConstraintUtil.alignTop(subView, to: contentView, offset: offset)
                    first = false
                } else {
                    ConstraintUtil.align(subView, below: preView, where: contentView, offset: 20)
                }
                preView = subView
            }
            ConstraintUtil.alignBottom(preView, to: contentView, offset: offset)
            DLog(message: "end")
        }
    }
}
