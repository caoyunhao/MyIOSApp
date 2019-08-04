//
//  GifPickerViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/12/29.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import Photos

class GifPickerViewController: ScrollViewController {
    
    @IBOutlet weak var selectButton: UIButton!
    
    fileprivate var items: [PhotoMultiSelectionItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = "Gif Picker"
        
        LayoutUtil.verticalCenterView(subViews: [
            selectButton,
            ], at: contentView, offset: 20)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction
    func selectAction() {
        
        let vc = PhotosPicker.albumsViewController {
            (assets) in
            self.handler(assets: assets)
        }
        vc.maxSelected = 1
        vc.autoClose = true
        vc.type = .image
        // vc.subTypes = [.]
        
        let navVC = UINavigationController(rootViewController: vc)
        
        self.present(navVC, animated: true)
        
        self.items = []
    }
    
    @objc
    func handler(assets: [PHAsset]) {
        let vc = CommonUtils.loadNib(ofViewControllerType: ImagesViewController.self) as! ImagesViewController
        vc.title = "Frames"
        vc.maxSelected = 100
        vc.autoClose = false
        
        vc.completeHandler = self.handler;
        
        AssetsUtils.handleImageData(of: assets.first!) { (data) in
            DLog(data)
            if let image = CYHImage(cfData: data as CFData) {
                DLog(image.description)
                self.items.append(contentsOf: image.images.map({ (uiImage) -> PhotoMultiSelectionItem in
                    return PhotoMultiSelectionItem(image: CYHImage(uiImage: uiImage))
                }))
                vc.items.append(contentsOf: self.items)
                // self.navigationController?.pushViewController(vc, animated: true)
                let navVC = UINavigationController(rootViewController: vc);
                self.present(navVC, animated: true)
            }
        }
    }
    
    @objc
    func handler(indexes: [Int]) {
        if indexes.count > 0 {
            indexes.forEach { (index) in
                self.items[index].image.saveAsSimple()
            }
            AlertUtils.simple(vc: self, message: "Save \(indexes.count) image(s) successfully~")
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
