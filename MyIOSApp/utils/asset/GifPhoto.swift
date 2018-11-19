//
//  GifPhoto.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/18.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class GifPhoto: NSObject {
    private var _images: [UIImage]
    private var _duration: Double
    
    private var _localIdentifier: String?
    
    var images: [UIImage] {
        return self._images
    }
    var duration: Double {
        return self._duration
    }
    
    var size: CGSize {
        return images.first!.size
    }
    
    var ratio: Float {
        return images.first!.ratio
    }
    
    var isGif: Bool {
        return images.count > 1
    }
    
    var perDelay: Double {
        return duration / Double(images.count)
    }
    
    init(images: [UIImage], duration: Double) {
        self._images = images
        self._duration = duration
        if images.count < 2 {
            self._duration = Double.infinity
        }
    }
    
    init(cgImages: [CGImage], duration: Double) {
        self._images = cgImages.map { (cgImage) in
            return UIImage(cgImage: cgImage)
        }
        self._duration = duration
        if cgImages.count < 2 {
            self._duration = Double.infinity
        }
    }
}
