//
//  ImagePreviewViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/6/27.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    
    private var imageScale: CGFloat = -1
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageScale = image.size.width / image.size.height
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        DLog(message: view.frame)
        DLog(message: imageView.frame)
        imageView.image = image
        
        if imageScale >= 1 {
            view.frame.size.height = view.frame.size.width / imageScale
        }
        
        if 0.0 < imageScale && imageScale < 1.0 {
            view.frame.size.width = view.frame.size.height * imageScale
        }
        DLog(message: view.frame)
        DLog(message: imageView.frame)
        
        preferredContentSize = view.frame.size

        // Do any additional setup after loading the view.
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
