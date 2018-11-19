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

class GifUtil {
    
    static func gifFrom(data: Data, handler: @escaping (_ gifPhoto: GifPhoto) -> Void) {
        let options: NSDictionary = [
            kCGImageSourceShouldCache as String: NSNumber(value: true),
            kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF
        ]
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, options) else {
            return
        }
        
        gifFrom(imageSource: imageSource, handler: handler)
    }
    
    static func gifFrom(imageSource: CGImageSource, handler: @escaping (_ gifPhoto: GifPhoto) -> Void) {
        let frameCount = CGImageSourceGetCount(imageSource)
        
        var images: [CGImage] = []
        var duration = Double.infinity
        
        if frameCount > 1 {
            duration = 0
        }
        
        DLog(message: frameCount)
        
        for i in 0 ..< frameCount {
            // 获取对应帧的 CGImage
            guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {
                continue
            }
            // gif 动画
            // 获取到 gif每帧时间间隔
            guard
                let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil),
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
        handler(GifPhoto(cgImages: images, duration: duration))
    }
    
    static func save(gif: GifPhoto, size: CGSize) {
        flush(gif: gif, process: {(image) in
            return image.e_resize(size: size)
        }) { (fileUrl) in
            do {
                let data = try Data(contentsOf: fileUrl)
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCreationRequest.forAsset().addResource(with: .photo, data: data, options: nil)
//                    PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileUrl as URL)
                }, completionHandler: {success, error in
                    if error != nil {
                        print("error")
                    } else if success {
                        print("success")
                    } else {
                        print("not completed")
                    }
                })
            } catch let error {
                DLog(message: error)
            }
//            PHPhotoLibrary.shared().performChanges({
//                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileUrl as URL)
//            }, completionHandler: {success, error in
//                if error != nil {
//                    print("error： \(error.debugDescription)")
//                } else if success {
//                    print("success")
//                } else {
//                    print("not completed")
//                }
//            })
        }
    }
    
    fileprivate static func flush(gif: GifPhoto, process: (UIImage) -> UIImage, completion: (URL) -> Void) {
        flush(images: gif.images, duration: gif.duration, process: process, completion: completion)
    }
    
    fileprivate static func flush(images: [UIImage], duration: Double, process: (UIImage) -> UIImage, completion: (URL) -> Void) {
        
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
                CGImageDestinationAddImage(destination, process(image).cgImage!, gifProperties as CFDictionary?)
            }
            
            if CGImageDestinationFinalize(destination) {
                completion(path as URL)
            }
        }
    }
}
