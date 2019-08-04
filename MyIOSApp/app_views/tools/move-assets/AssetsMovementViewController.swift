//
//  AssetsMovementViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/18.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import Photos

class AssetsMovementViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var actionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = "Move Assets"
        contentView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        ConstraintUtil.alignCompletely(view, child: contentView)
        
        LayoutUtil.verticalCenterView(subViews: [actionButton], at: contentView, offset: 20)
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
        vc.completeHandler = self.handler;
        
        let navVC = UINavigationController(rootViewController: vc)
        
        self.present(navVC, animated: true)
    }
    
    @objc
    func handler(assets: [PHAsset]) {
        DLog("move \(assets.count) photos.")
//        AssetsUtils.doViaLivePhotoSource(livePhotoAsset: assets[0], imageHandler: {
//            (image) in
//            AssetsUtils.save(image: image)
//        })
        
        AssetsUtils.move(assets: assets, titleOfTargetAlbum: "123123123", delete: false)
//                AssetsUtils.move(assets: assets, titleOfTargetAlbum: "ZZZ", delete: true)
    }
}
