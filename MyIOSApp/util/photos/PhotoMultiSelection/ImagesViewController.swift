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
    static var imageManager: PHCachingImageManager = PHCachingImageManager()
    
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
        collectionView.cellSpace = cellSpace
        collectionView.columnsNum = columnsNum
        collectionView.setup()
        
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
        let imageManager = ImagesViewController.imageManager
        //初始化和重置缓存
//        ImagesViewController.imageManager.stopCachingImagesForAllAssets()
        self.assetsFetchResults?.enumerateObjects { (asset, index, _) in
            imageManager.requestImage(
                for: asset,
                targetSize: self.assetGridThumbnailSize,
                contentMode: .aspectFill,
                options: nil) { (image, nfo) in
                    if let image = image {
                        let type: CYHImageType = asset.mediaSubtypes.contains(.photoLive) ? .live : .general
                        self.items.append(PhotoMultiSelectionItem(image: CYHImage(type: type, uiImages: [image], asset: asset)))
                    } else {
                        self.items.append(PhotoMultiSelectionItem(image: CYHImage(type: .general, uiImages: [UIImage(color: UIColor.white)!], asset: asset)))
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
//            let point = pan.accessibilityActivationPoint
//            DLog(message: point)
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
        cell.data = self.items[indexPath.row]
        registerForPreviewing(with: self, sourceView: cell.contentView)
        
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

extension ImagesViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
    
        let cell = previewingContext.sourceView.superview as! ImagesViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        
        let vc = CommonUtils.loadNib(ofViewControllerType: ImagePreviewViewController.self) as! ImagePreviewViewController
        
        if let asset = assetsFetchResults?.object(at: indexPath.row) {
            DLog(message: 3344)
            AssetsUtils.handleImageDataSynchronous(of: asset) { (data) in
                DLog(message: 444)
                if let image = CYHImage(data: data) {
                    vc.image = image
                    DLog(message: 555)
                }
            }
        } else {
            if let image = cell.imageView.image {
                DLog(message: 333)
                vc.image = CYHImage(uiImage: image)
            } else {
                AlertUtils.simple(vc: self, message: "error")
            }
            
            DLog(message: 666)
        }
        DLog(message: 100000)
        
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
    
    
}
