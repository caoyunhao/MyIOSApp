//
//  CYHImageView.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/6/27.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class CYHImageView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    fileprivate var rotateRate_ : Int = 0
    
    var rotateRate: Int {
        set {
            DLog(message: "oldValue=\(rotateRate_), newValue=\(newValue)")
            let times = (360 - abs(rotateRate_ - newValue)) % 90
            rotateRate_ = newValue
            for _ in 0...times {
                rotateLeft90_()
            }
        }
        get {
            return rotateRate_
        }
    }
    
    var imageScale: CGFloat {
        if (rotateRate % 180 == 0) {
            return image!.size.width / image!.size.height
        } else {
            return image!.size.height / image!.size.width
        }
    }
    
    var image: CYHImage? {
        didSet {
            if let image = image {
                DLog(message: "imageScale=\(String(describing: imageScale))")
                DLog(message: "frame.size=\(frame.size)")
                computeSize();
                
                self.imageView.stopAnimating()
                self.imageView.animationImages = image.images
                self.imageView.animationDuration = image.duration
                self.imageView.animationRepeatCount = 0
                self.imageView.startAnimating()
            }
        }
    }
    
    fileprivate func computeSize() {

        let imageScale = self.imageScale
        
        let parentSize = frame.size
        let maxHeight = parentSize.height
        let maxWidth = parentSize.width
        
        let viewScale = maxWidth / maxHeight // > 1
        
        imageView.frame.size.height = maxHeight
        imageView.frame.size.width = maxWidth
        imageView.frame.origin.x = 0
        imageView.frame.origin.y = 0
        
        if imageScale > viewScale {
            // 更宽，需要减少高度，高度=最大宽度 / 图片比例
            imageView.frame.size.height = min(maxWidth / imageScale, maxHeight)
            imageView.frame.origin.y = (parentSize.height - imageView.frame.size.height) / 2
        }
        
        if 0.0 < imageScale && imageScale <= viewScale {
            // 更高，需要减少k宽度，宽度=最大高度*图片比例
            imageView.frame.size.width = min(maxHeight * imageScale, maxWidth)
            imageView.frame.origin.x = (parentSize.width - imageView.frame.size.width) / 2
        }

        DLog(message: "imageView.frame=\(imageView.frame)")
    }
    
    func rotateLeft90() {
        self.rotateRate = (self.rotateRate + 90) % 360
    }
    
    func rotateLeft90_() {
        DLog(message: "rotateLeft90_")
        UIView.animate(withDuration: 0.3) {
            self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2 * Double(self.rotateRate / 90)))
            self.computeSize()
        }
    }
    
    func reset() {
        self.rotateRate = 0
    }
}
