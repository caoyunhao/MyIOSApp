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
    
    var columnsNum: Int = 4
    var cellSpace: CGFloat = 1
    var widthTotal: CGFloat?
    
    func setup() {
        let spaceNum = columnsNum + 1
        
        //设置单元格尺寸
        let layout = (collectionViewLayout as! UICollectionViewFlowLayout)
        //        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4 - 1,
        //                                 height: UIScreen.main.bounds.size.width/4 - 1)
        layout.minimumInteritemSpacing = cellSpace
        //垂直行间距
        layout.minimumLineSpacing = cellSpace
        
        //整个view的宽度
        let widthTotal = self.widthTotal ?? bounds.width
        //整个view横向除去间距后，剩余的像素个数
        let rowsWidth = widthTotal - CGFloat(spaceNum) * cellSpace
        
        //单元格宽度（点）
        let itemWidth = CGFloat(Int(rowsWidth / CGFloat(columnsNum)))
        
        //设置单元格宽度和高度
        layout.itemSize = CGSize(width:itemWidth, height:itemWidth)
        layout.sectionInset = .zero
        
        //剩余像素（作为左右内边距）
        let remainder = widthTotal - rowsWidth - CGFloat(columnsNum - 1) * cellSpace
        //左内边距
        let paddingLeft = CGFloat(Int(remainder/2))
        //右内边距做-0.001特殊处理，否则在plus设备下可能摆不下
        let paddingRight = remainder - paddingLeft - 0.001
        
//        DLog("cellSpace=\(cellSpace), spaceNum=\(spaceNum), widthTotal=\(widthTotal), itemWidth=\(itemWidth), remainder=\(remainder), paddingLeft=\(paddingLeft), paddingRight=\(paddingRight)")
        //设置内边距
        layout.sectionInset = UIEdgeInsets(top: paddingLeft, left: paddingLeft,
                                           bottom: paddingLeft, right: paddingRight)
    }
}
