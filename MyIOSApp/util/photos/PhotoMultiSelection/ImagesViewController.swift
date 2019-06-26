//
//  ImagesViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/20.
//  Copyright © 2018 Yunhao. All rights reserved.
//
import UIKit
import Photos
import PhotosUI

private let reuseIdentifier = "ImagesViewCell"

class ImagesViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    let cellSpace = 1 / UIScreen.main.scale
    let columnsNum = 4
    // 完成按钮
    var completeButton: UIButton!
    var closeButton: UIButton!
    
    //取得的资源结果，用了存放的PHAsset
    var assetsFetchResults: PHFetchResult<PHAsset>?
    
    var items: [PhotoMultiSelectionItem] = []
    
    //带缓存的图片管理对象
    var imageManager: PHCachingImageManager!
    
    //缩略图大小
    var assetGridThumbnailSize: CGSize!
    
    //每次最多可选择的照片数量
    var maxSelected: Int = 4
    var autoClose: Bool = false
    
    //照片选择完毕后的回调
    var completeHandler:((_ indexes:[Int])->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.setupData()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
        pan.minimumNumberOfTouches = 1;
        pan.maximumNumberOfTouches = 1;
        self.view.addGestureRecognizer(pan)
        
//        self.collectionView.addGestureRecognizer()
    }
    
    fileprivate func setupLayout() {
        let collectionView = CYHCollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        ConstraintUtil.alignCompletely(self.view, child: collectionView)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //背景色设置为白色（默认是黑色）
        self.collectionView?.backgroundColor = UIColor.white
        
        collectionView.setup()
        
//        //设置单元格尺寸
//        let layout = (self.collectionView!.collectionViewLayout as!
//            UICollectionViewFlowLayout)
//        //        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4 - 1,
//        //                                 height: UIScreen.main.bounds.size.width/4 - 1)
//        layout.minimumInteritemSpacing = cellSpace
//        //垂直行间距
//        layout.minimumLineSpacing = cellSpace
//
//        //整个view的宽度
//        let collectionViewWidth = self.collectionView!.bounds.width
//        //整个view横向除去间距后，剩余的像素个数
//        let pxWidth = collectionViewWidth * UIScreen.main.scale - CGFloat(columnsNum - 1)
//
//        //单元格宽度（像素）
//        let itemWidthPx = CGFloat(Int(pxWidth / CGFloat(columnsNum)))
//        //单元格宽度（点）
//        let itemWidth = itemWidthPx / UIScreen.main.scale
//
//        //设置单元格宽度和高度
//        layout.itemSize = CGSize(width:itemWidth, height:itemWidth)
//
//        //剩余像素（作为左右内边距）
//        let remainderPx = pxWidth - itemWidthPx * CGFloat(columnsNum)
//
//        //左内边距
//        let paddingLeftPx = CGFloat(Int(remainderPx/2))
//        let paddingLeft = paddingLeftPx / UIScreen.main.scale
//
//        //右内边距
//        let paddingRightPx = remainderPx - paddingLeftPx
//        //右内边距做-0.001特殊处理，否则在plus设备下可能摆不下
//        let paddingRight = paddingRightPx / UIScreen.main.scale - 0.001
//
//        //设置内边距
//        layout.sectionInset = UIEdgeInsets(top: 0, left: paddingLeft,
//                                           bottom: 0, right: paddingRight)
        let layout = (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout)
        assetGridThumbnailSize = CGSize(
            width: layout.itemSize.width * UIScreen.main.scale,
            height: layout.itemSize.height * UIScreen.main.scale)
        
        //允许多选
        self.collectionView?.allowsMultipleSelection = true
        self.collectionView?.alwaysBounceVertical = true
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.finishSelect))
        ]
    }
    
    fileprivate func setupData() {
        self.imageManager = PHCachingImageManager()
        //初始化和重置缓存
        self.imageManager.stopCachingImagesForAllAssets()
        self.assetsFetchResults?.enumerateObjects { (asset, index, _) in
            PHCachingImageManager().requestImage(
                for: asset,
                targetSize: self.assetGridThumbnailSize,
                contentMode: .aspectFill,
                options: nil) { (image, nfo) in
                    if let image = image {
                        let type: CYHImageType = asset.mediaSubtypes.contains(.photoLive) ? .live : .general
                        self.items.append(PhotoMultiSelectionItem(image: CYHImage(type: type, uiImages: [image])))
                    } else {
                        self.items.append(PhotoMultiSelectionItem(image: CYHImage(type: .general, uiImages: [UIImage(color: UIColor.white)!])))
                    }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //取消按钮点击
    @objc func cancel() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //获取已选择个数
    func selectedCount() -> Int {
        return self.collectionView!.indexPathsForSelectedItems?.count ?? 0
    }
    
    //完成按钮点击
    @IBAction
    func finishSelect() {
        //取出已选择的图片资源
        if let indexPaths = self.collectionView?.indexPathsForSelectedItems {
            DLog(message: "已选择的: \(indexPaths)")
            //调用回调函数
            self.navigationController?.dismiss(animated: true, completion: {
                self.completeHandler?(indexPaths.map({ (indexPath) -> Int in
                    return indexPath.row
                }))
            })
        } else {
            self.navigationController?.dismiss(animated: true, completion: {
                self.completeHandler?([])
            })
        }
    }
    
    @objc
    fileprivate func handlePan(pan: UIPanGestureRecognizer) {
        DLog(message: pan)
        self.collectionView.visibleCells.forEach { (cell) in
            let point = pan.accessibilityActivationPoint
            DLog(message: point)
        }
    }
    
}

extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! ImagesViewCell
        // Configure the cell
        let item = self.items[indexPath.row]
        
        if item.image.type == .live {
            cell.badgeImageView.image = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
        } else {
            cell.badgeImageView.image = nil
        }
        
        //获取缩略图
//        self.imageManager.requestImage(for: asset,targetSize: assetGridThumbnailSize,contentMode: .aspectFill,options: nil) {
//            (image, nfo) in
//            cell.imageView.image = image
//
//        }
        
        cell.imageView.image = item.image.first
        
        return cell
    }
    
    //单元格选中响应
    func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath)
            as? ImagesViewCell{
            
            if (selectedCount() > maxSelected) {
                collectionView.deselectItem(at: indexPath, animated: true)
                AlertUtils.simple(vc: self, message: "最多选择\(maxSelected)个~")
            } else {
                cell.select()
            }
            
            if (self.autoClose && selectedCount() >= maxSelected) {
                finishSelect();
            }
        }
    }
    
    //单元格取消选中响应
    func collectionView(_ collectionView: UICollectionView,
                                 didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath)
            as? ImagesViewCell{
            cell.deselect()
        }
    }
    
    static func new() {
        
    }
}
