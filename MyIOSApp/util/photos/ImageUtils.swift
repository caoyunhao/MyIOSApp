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

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

class ImageUtils {
    
    static func buildImage(from data: Data) -> CYHImage? {
        let options: NSDictionary = [
            kCGImageSourceShouldCache as String: NSNumber(value: true),
            kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF
        ]
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, options) else {
            return nil
        }
        
        return buildImage(from: imageSource)
    }
    
    static func buildImage(from source: CGImageSource) -> CYHImage {
        let frameCount = CGImageSourceGetCount(source)
        
        var images: [CGImage] = []
        var duration = frameCount > 1 ? 0 : Double.infinity
        
        DLog(message: frameCount)
        
        for i in 0 ..< frameCount {
            // 获取对应帧的 CGImage
            guard let imageRef = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                continue
            }
            // gif 动画
            // 获取到 gif每帧时间间隔
            guard
                let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil),
                let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else {
                    // 不是Gif
                    images.append(imageRef)
                    continue
            }
            
            if frameCount > 1 {
                duration += frameDuration.doubleValue
            }
            // 获取帧的img
            images.append(imageRef)
        }
        DLog(message: images.count)
        DLog(message: duration)
        return CYHImage(cgImages: images, duration: duration)
    }
    
    static func save(_ image: CYHImage) {
        if (image.type == .gif) {
            saveAsGif(image)
        } else {
            saveAsSimple(image)
        }
    }
    
    static func saveAsGif(_ image: CYHImage) {
        DLog(message: "save as gif")
        flush(image: image) { (fileUrl) in
            if let data = try? Data(contentsOf: fileUrl) {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCreationRequest.forAsset().addResource(with: .photo, data: data, options: nil)
                }, completionHandler: {success, error in
                    DLog(message: "success: \(success), error: \(error.debugDescription)")
                })
            }
        }
    }
    
    static func saveAsSimple(_ image: CYHImage) {
        DLog(message: "save as simple")
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image.first)
        }, completionHandler: {success, error in
            DLog(message: "success: \(success), error: \(error.debugDescription)")
        })
    }
    
    fileprivate static func flush(image: CYHImage, completion: (URL) -> Void) {
        flush(images: image.images, duration: image.duration, completion: completion)
    }
    
    fileprivate static func flush(images: [UIImage], duration: Double, completion: (URL) -> Void) {
        
        let path = AssetsUtils.generateTemporaryFile()
        
        DLog(message: "path: \(path.debugDescription)")
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
