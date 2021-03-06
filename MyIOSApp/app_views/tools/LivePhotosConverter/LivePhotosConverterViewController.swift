//
//  LivePhotosConverterViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/17.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class LivePhotosConverterViewController: UIViewController {

    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var toLivePhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false

        ConstraintUtil.alignCompletely(view, child: contentView)
        
        LayoutUtil.verticalCenterView(subViews: [actionButton, toLivePhotoButton], at: contentView, offset: 20)
        
        navigationItem.largeTitleDisplayMode = .never
        title = "Convert Live Photos"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction
    func action() {
//        let vc = UIStoryboard(name: "AlbumsView", bundle: nil).instantiateInitialViewController() as? AlbumsViewController
        let vc = PhotosPicker.albumsViewController {
            (assets) in
            self.handler(assets: assets)
        }
        vc.maxSelected = -1
        vc.type = .image
        vc.subTypes.append(.photoLive)
        
        let navVC = UINavigationController(rootViewController: vc)
        
        self.present(navVC, animated: true)
    }
    
    @objc
    func handler(assets: [PHAsset]) {
        let total = assets.count
        var liveCnt: Int = 0
        let options = UINotice.Options()
        options.autoCleanTimeInterval = -1
        options.hasProgress = true
        options.autoLayout = true
        let notice = UINotice(text: "已转换", options: options)
        notice.show()
        DispatchQueue.global().async {
            for asset in assets {
                if asset.mediaSubtypes.contains(.photoLive) {
                    liveCnt += 1;
                    let paths = LivePhotosUtil.saveLivePhotoToLibray(livePhotoAsset: asset, mediaTypes: [.video], toAlbum: "Live Photos Convert")
                    DispatchQueue.main.async {
                        notice.progress = Double(liveCnt) / Double(total)
                        notice.text = "\(liveCnt)/\(total)"
                    }
                }
            }
            DispatchQueue.main.async {
                notice.text = "转换完成"
                notice.hide(afterDelay: 1)
            }
        }
    }
    
    @IBAction
    func toLivePhotoAction() {
        let vc = PhotosPicker.albumsViewController {
            (assets) in
            self.toLivePhotoHandler(assets: assets)
        }
        
        vc.type = .video
        vc.maxSelected = -1
        
        let navVC = UINavigationController(rootViewController: vc)
        
        self.present(navVC, animated: true)
    }
    
    func toLivePhotoHandler(assets: [PHAsset]) {
        let uiOptions = UINotice.Options()
        uiOptions.hasProgress = true
        uiOptions.autoCleanTimeInterval = -1
        
        let notice = UINotice(text: "开始转换", options: uiOptions)
        notice.show()
        
        DispatchQueue.global().async {
            let s = DispatchSemaphore(value: 0)
            var successCount = 0
            assets.forEach { (asset) in
                DLog("enter")
                //            group.enter()
                let options = PHVideoRequestOptions()
                options.version = .current
                PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: { (avAsset, audioMix, info) in
                    if let avAsset = avAsset {
                        SaveLivePhotosToLibary(avAsset: avAsset) { (success, error) in
                            if success {
                                successCount += 1
                            } else {
                                AlertUtils.simple(vc: self, message: "\(LocalizedStrings.FAIL)：\(String(describing: error))")
                            }
                            s.signal()
                            DispatchQueue.main.async {
                                notice.text = "已完成(\(successCount)/\(assets.count))"
                            }
                        }
                    } else {
                        AlertUtils.simple(vc: self, message: "读取视频失败")
                        s.signal()
                    }
                })
                s.wait()
            }
            DispatchQueue.main.async {
                notice.text = "转换完成"
                notice.hide(afterDelay: 1)
            }
        }
    }
}
