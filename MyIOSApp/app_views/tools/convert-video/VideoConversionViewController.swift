//
//  VedioConversionViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/18.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import Photos

class VideoConversionViewController: ScrollViewController {
    @IBOutlet weak var nFramesPerSecTextField: UITextField!
    @IBOutlet weak var toGifButton: UIButton!
    @IBOutlet weak var progressBarView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        progressBarView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
//        //        progressView.center = self.view.center;
        
//        progressBarView.frame = CGRect(origin: CGPoint(x: 10, y: 590), size: CGSize(width: 200, height: 30))
//        progressBarView.progress = 0.0
//
//        LayoutUtil.verticalCenterView(subViews: [
//            nFramesPerSecTextField,
//            toGifButton,
//            progressBarView,
//        ], at: contentView, offset: 20)
//        
//        ConstraintUtil.setWidth(progressBarView, 200, where: contentView)
        
        navigationItem.largeTitleDisplayMode = .never
        title = "Convert Video"
        
        
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction
    func toGifAction() {
        
        let vc = PhotosPicker.albumsViewController {
            (assets) in
            self.handler(assets: assets)
        }
        vc.maxSelected = 1
        vc.type = .video
        
        let navVC = UINavigationController(rootViewController: vc)
        
        self.present(navVC, animated: true)
    }
    
    @objc
    func handler(assets: [PHAsset]) {
        DLog("handle \(assets.count) video(es).")
        let total = assets.count
        var count = 0
        
        assets.forEach {(asset) in
            count += 1;
            AssetsUtils.getAVAsset(forVideo: asset, handle: { (asset) in
                let url = AssetsUtils.generateTemporaryDirectory().appendingPathComponent("\(UUID().uuidString).gif", isDirectory: false)
                let request = VideoUtil.Video2GifRequest(asset: asset, savePath: url!, framesPreSecond: Int(self.nFramesPerSecTextField.text ?? "10") ?? 10);
                VideoUtil.convertToGif(request: request, processRate: { (rate) in
                    DispatchQueue.main.async {
                        self.progressBarView.setProgress(rate, animated: true)
                    }
                }) { (url) in
                    AssetsUtils.saveImage(atFileURL: url) { (success, error) in
                        AlertUtils.simple(vc: self, message: "完成 \(count)/\(total)")
                    }
                }
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
