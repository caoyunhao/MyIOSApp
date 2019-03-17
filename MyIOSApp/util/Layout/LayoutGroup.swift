//
//  LayoutGroup.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/29.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation
import UIKit

class LayoutGroup {
    private var view: UIView!
    private var toView: UIView!
    
    public init (_ view: UIView, to toView: UIView) {
        self.view = view
        self.toView = toView
    }
    
//    public func alignLeft() {
//        LayoutHelper.alignLeft(view, to: toView)
//    }
//
//    public func alignCompletely() {
//        LayoutHelper.alignCompletely(view, child: toView)
//    }
}
