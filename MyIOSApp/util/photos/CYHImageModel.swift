//
//  CYHImageModel.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/18.
//  Copyright © 2018 Yunhao. All rights reserved.
//
import ImageIO
import UIKit
import Photos
import MobileCoreServices

enum CYHImageType {
    case general
    case live
    case gif
}

class CYHImage: NSObject {
    var asset: PHAsset?
    private(set) var images: [UIImage]
    private(set) var duration: Double = Double.infinity
    private(set) var type: CYHImageType = .general
    private var localIdentifier: String?
    private(set) var properties: CFDictionary?
    private(set) var sourceType: CFString?
    
    override var description: String {
        return """
        \(super.description)
        duration: \(duration)
        type: \(type)
        localIdentifier: \(String(describing: localIdentifier))
        properties: \(String(describing: properties))
        sourceType: \(String(describing: sourceType))
        asset: \(asset?.cyhDescriptionFormatted ?? "nil")
        """
    }
    
    convenience init(type: CYHImageType, uiImages: [UIImage], asset: PHAsset? = nil) {
        self.init(type: type, uiImages: uiImages, duration: Double.infinity, asset: asset)
    }
    
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
    
    convenience init?(data: Data) {
        self.init(cfData: data as CFData)
    }
    
    convenience init?(cfData: CFData) {
        let options: NSDictionary = [
            kCGImageSourceShouldCache as String: NSNumber(value: true),
            kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF
        ]
        
        guard let imageSource = CGImageSourceCreateWithData(cfData, options) else {
            return nil
        }
        
        self.init(source: imageSource)
    }
    
    convenience init(source: CGImageSource) {
        let frameCount = CGImageSourceGetCount(source)
        var images: [CGImage] = []
        var duration = frameCount > 1 ? 0 : Double.infinity
        DLog(frameCount)
        for i in 0 ..< frameCount {
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
            images.append(imageRef)
        }
        DLog(images.count)
        DLog(duration)
        
        self.init(cgImages: images, duration: duration)
        
        let options: NSDictionary = [
            kCGImageSourceShouldCache as String: NSNumber(value: true),
            kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF
        ]
        self.properties = CGImageSourceCopyProperties(source, options)
        self.sourceType = CGImageSourceGetType(source)
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
        return newImage(CYHImage(type: type, uiImages: images.map({ (image) -> UIImage in
            return image.e_resize(size: size)
        }), duration: duration, asset: asset))
    }
    
    func rotateLeft90() -> CYHImage {
        return newImage(CYHImage(type: type, uiImages: images.map({ (image) -> UIImage in
            return image.e_rotateLeft90()
        }), duration: duration, asset: asset))
    }
    
    fileprivate func newImage(_ newImage: CYHImage) -> CYHImage {
        newImage.properties = self.properties
        newImage.sourceType = self.sourceType
        return newImage
    }
    
    func save() {
        if (type == .gif) {
            saveAsGif()
        } else {
            saveAsSimple()
        }
    }
    
    func saveAsGif() {
        DLog("save as gif")
        flushAsTemporaryFile() { (fileUrl) in
            if let data = try? Data(contentsOf: fileUrl) {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCreationRequest.forAsset().addResource(with: .photo, data: data, options: nil)
                }, completionHandler: {success, error in
                    DLog("success: \(success), error: \(error.debugDescription)")
                })
            }
        }
    }
    
    func saveAsSimple() {
        DLog("save as simple")
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: self.first)
        }, completionHandler: {success, error in
            DLog("success: \(success), error: \(error.debugDescription)")
        })
    }
    
    func flushAsTemporaryFile(completion: (URL) -> Void) {
        ImageUtils.flushAsTemporaryFile(images: self.images, duration: self.duration, completion: completion)
    }
}
