//
//  CYHCollectionView.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/6/19.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class CYHCollectionView: UICollectionView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setup() {
        let cellSpace = 1 / UIScreen.main.scale
        let columnsNum = 4
        
        //设置单元格尺寸
        let layout = (collectionViewLayout as! UICollectionViewFlowLayout)
        //        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4 - 1,
        //                                 height: UIScreen.main.bounds.size.width/4 - 1)
        
        
        layout.minimumInteritemSpacing = cellSpace
        //垂直行间距
        layout.minimumLineSpacing = cellSpace
        
        //整个view的宽度
        let collectionViewWidth = bounds.width
        //整个view横向除去间距后，剩余的像素个数
        let pxWidth = collectionViewWidth * UIScreen.main.scale - CGFloat(columnsNum - 1)
        
        //单元格宽度（像素）
        let itemWidthPx = CGFloat(Int(pxWidth / CGFloat(columnsNum)))
        //单元格宽度（点）
        let itemWidth = itemWidthPx / UIScreen.main.scale
        
        //设置单元格宽度和高度
        layout.itemSize = CGSize(width:itemWidth, height:itemWidth)
        
        //剩余像素（作为左右内边距）
        let remainderPx = pxWidth - itemWidthPx * CGFloat(columnsNum)
        
        //左内边距
        let paddingLeftPx = CGFloat(Int(remainderPx/2))
        let paddingLeft = paddingLeftPx / UIScreen.main.scale
        
        //右内边距
        let paddingRightPx = remainderPx - paddingLeftPx
        //右内边距做-0.001特殊处理，否则在plus设备下可能摆不下
        let paddingRight = paddingRightPx / UIScreen.main.scale - 0.001
        
        //设置内边距
        layout.sectionInset = UIEdgeInsets(top: 0, left: paddingLeft,
                                           bottom: 0, right: paddingRight)
    }

}
