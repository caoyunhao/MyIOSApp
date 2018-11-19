//
//  CGSize.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/27.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

extension CGSize {
    
}

func *(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
}

func *(left: CGSize, right: Float) -> CGSize {
    let _right = CGFloat(right)
    return left * _right
}
