//
//  view-utils.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/2/26.
//  Copyright © 2019 Yunhao. All rights reserved.
//
import UIKit
import AVFoundation

func drawOutlines(in layer: CAShapeLayer, object : AVMetadataMachineReadableCodeObject) {
    let corners = object.corners
    
    if corners.count == 0 {
        return
    }

    // 3.创建UIBezierPath绘制矩形
    
    let linePath = UIBezierPath()
    linePath.lineWidth = 5

    for (i, corner) in corners.enumerated() {
        if i == 0 {
            linePath.move(to: corner)
        } else {
            linePath.addLine(to: corner)
        }
    }
    // 6.关闭路径
    linePath.close()
    layer.path = linePath.cgPath
}
