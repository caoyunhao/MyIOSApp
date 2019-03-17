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
    
    // 2.创建保存视图的图层
    layer.frame = UIScreen.main.bounds
    layer.borderWidth = 2
    layer.fillColor = UIColor.clear.cgColor
    layer.strokeColor = UIColor.red.cgColor
    
    // 3.创建UIBezierPath绘制矩形
    let linePath = UIBezierPath()
    linePath.lineWidth = 5
    
    var point = CGPoint()
    var index = 0
    
    // point = CGPoint(dictionaryRepresentation: array[index] as! CFDictionary)!
    point = corners[index]
    index += 1
    // 4.连接线段到某个点
    linePath.move(to: point)
    // 5.连接其他的点
    while index < corners.count {
        DLog(message: index)
        point = corners[index]
        DLog(message: point)
        index += 1
        linePath.addLine(to: point)
    }
    // 6.关闭路径
    linePath.close()
    layer.path = linePath.cgPath
}
