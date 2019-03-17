//
//  LivePhotosConverterViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/17.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import Photos

class LivePhotosConverterViewController: UIViewController {

    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false

        ConstraintUtil.alignCompletely(view, child: contentView)
        
        LayoutUtil.verticalCenterView(subViews: [actionButton], at: contentView, offset: 20)
        
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
        let vc = PhotosPickerUtils.albumsViewController {
            (assets) in
            self.handler(assets: assets)
        }
        
        vc.type = .image
        vc.subTypes.append(.photoLive)
        
        let navVC = UINavigationController(rootViewController: vc)
        
        self.present(navVC, animated: true)
    }
    
    @objc
    func handler(assets: [PHAsset]) {
        DLog(message: "handle \(assets.count) photos.")
        let total = assets.count
        var liveCnt: Int = 0
        
        assets.forEach {(asset) in
            if asset.mediaSubtypes.contains(.photoLive) {
                liveCnt += 1;
                LivePhotosUtil.save(livePhotoAsset: asset)
            }
        }

        AlertUtils.simple(vc: self, message: "完成 \(liveCnt)/\(total)")
    }
}
