//
//  CYHImageModel.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/18.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import Photos

enum CYHImageType {
    case general
    case live
    case gif
}

class CYHImage: NSObject {
    private(set) var asset: PHAsset?
    private(set) var images: [UIImage]
    private(set) var duration: Double = Double.infinity
    private(set) var type: CYHImageType = .general
    private var localIdentifier: String?
    
    init(type: CYHImageType, uiImages: [UIImage], duration: Double = Double.infinity, asset: PHAsset? = nil) {
        self.images = uiImages
        self.type = type
        self.duration = duration
        self.asset = asset
    }
    
    init(uiImages: [UIImage], duration: Double) {
        self.images = uiImages
        if uiImages.count > 1 {
            self.duration = duration
            self.type = .gif
        }
    }
    
    convenience init(uiImage: UIImage) {
        self.init(uiImages: [uiImage], duration: Double.infinity)
    }
    
    convenience init(cgImages: [CGImage], duration: Double) {
        let uiImages = cgImages.map { (cgImage) in
            return UIImage(cgImage: cgImage)
        }
        self.init(uiImages: uiImages, duration: duration)
    }
    
    var size: CGSize {
        return images.first!.size
    }
    
    var ratio: Float {
        return images.first!.ratio
    }
    
    var perFrameDelay: Double {
        return duration / Double(images.count)
    }
    
    var first: UIImage {
        return images.first!
    }
    
    func resize(_ size: CGSize) -> CYHImage {
        return CYHImage(type: type, uiImages: images.map({ (image) -> UIImage in
            return image.e_resize(size: size)
        }), duration: duration, asset: asset)
    }
    
    func rotateLeft90() -> CYHImage {
        return CYHImage(type: type, uiImages: images.map({ (image) -> UIImage in
            return image.e_rotateLeft90()
        }), duration: duration, asset: asset)
    }
}
