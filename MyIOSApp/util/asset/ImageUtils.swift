//
//  GifUtil.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/18.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import Photos
import ImageIO
import MobileCoreServices

struct FlushResult {
    var fileUrl: URL
}

//class JPEG {
//    var data: Data?
//    init(cgImage: CGImage) {
//        data = UIImageJPEGRepresentation(UIImage(cgImage: cgImage), 1.0)
//    }
//
//    func write(path: String) {
//
//    }
//}

extension UIImage {
    
}

class ImageUtils {
    
//    static func saveAsGif(_ image: CYHImage) {
//        DLog("save as gif")
//        flush(image: image) { (fileUrl) in
//            if let data = try? Data(contentsOf: fileUrl) {
//                PHPhotoLibrary.shared().performChanges({
//                    PHAssetCreationRequest.forAsset().addResource(with: .photo, data: data, options: nil)
//                }, completionHandler: {success, error in
//                    DLog("success: \(success), error: \(error.debugDescription)")
//                })
//            }
//        }
//    }
//
//    static func saveAsSimple(_ image: CYHImage) {
//        DLog("save as simple")
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetChangeRequest.creationRequestForAsset(from: image.first)
//        }, completionHandler: {success, error in
//            DLog("success: \(success), error: \(error.debugDescription)")
//        })
//    }
    
    static func flushAsTemporaryFile(images: [UIImage], duration: Double, completion: (URL) -> Void) {
        
        let path = AssetsUtils.generateTemporaryFile()
        
        DLog("path: \(path.debugDescription)")
        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]
        let gifProperties = [
            kCGImagePropertyGIFDictionary as String:
                [kCGImagePropertyGIFDelayTime as String: duration / Double(images.count)]
        ]
        if let destination = CGImageDestinationCreateWithURL(path as CFURL, kUTTypeGIF, images.count, nil) {
            CGImageDestinationSetProperties(destination, fileProperties as CFDictionary?)
            
            images.forEach { (image) in
                CGImageDestinationAddImage(destination, image.cgImage!, gifProperties as CFDictionary?)
            }
            
            if CGImageDestinationFinalize(destination) {
                completion(path as URL)
            }
        }
    }
}
