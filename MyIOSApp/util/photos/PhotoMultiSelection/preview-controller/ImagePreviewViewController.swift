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
    
    var image: CYHImage! {
        didSet {
            imageScale = image.size.width / image.size.height
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CYHImageHolderView.fitParentSize(parentMaxSize: view.frame.size, imageScale: imageScale)
        
        imageView.image = image?.first

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
