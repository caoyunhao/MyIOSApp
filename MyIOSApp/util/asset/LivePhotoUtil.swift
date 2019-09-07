//
//  LivePhotoUtil.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/18.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation
import Photos
import MobileCoreServices

func SaveLivePhotosToLibary(videoURL: URL, completionHandler: ((Bool, Error?) -> Void)? = nil) {
    SaveLivePhotosToLibary(avAsset: AVURLAsset(url: videoURL), completionHandler: completionHandler)
}

func SaveLivePhotosToLibary(avAsset: AVAsset, completionHandler: ((Bool, Error?) -> Void)? = nil) {
    let generator = AVAssetImageGenerator(asset: avAsset)
    generator.appliesPreferredTrackTransform = true
    let time = NSValue(time: CMTimeMakeWithSeconds(CMTimeGetSeconds(avAsset.duration)/2, avAsset.duration.timescale))
    generator.generateCGImagesAsynchronously(forTimes: [time]) { _, image, _, _, _ in
        if let image = image, let data = UIImagePNGRepresentation(UIImage(cgImage: image)) {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let imageURL = urls[0].appendingPathComponent("image.jpg")
            try? data.write(to: imageURL, options: [.atomic])
            
            let imagePath = imageURL.path
            
            let output = AssetsUtils.generateTemporaryDirectory().path!
            let imageUrl = output + "/IMG.JPG";
            let movUrl = output + "/IMG.MOV";
            let assetIdentifier = UUID().uuidString
            
            try? FileManager.default.createDirectory(atPath: output, withIntermediateDirectories: true, attributes: nil)
            try? FileManager.default.removeItem(atPath: imageUrl)
            try? FileManager.default.removeItem(atPath: movUrl)
            
            JPEG(path: imagePath).write(imageUrl, assetIdentifier: assetIdentifier)
            QuickTimeMov(avAsset: avAsset).write(movUrl, assetIdentifier: assetIdentifier)
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                
                creationRequest.addResource(with: .pairedVideo, fileURL: URL(fileURLWithPath: movUrl), options: nil)
                creationRequest.addResource(with: .photo, fileURL: URL(fileURLWithPath: imageUrl), options: nil)
                
            }, completionHandler: completionHandler)
            
            //                _ = DispatchQueue.main.sync {
            //                    PHLivePhoto.request(withResourceFileURLs: [URL(fileURLWithPath: movUrl), URL(fileURLWithPath: imageUrl)], placeholderImage: nil, targetSize: self.view.bounds.size, contentMode: .aspectFit) { (livePhoto, info) in
            //                        DLog("PHLivePhoto.request.resultHandler.start ")
            //
            //                        DLog("PHLivePhoto.request.resultHandler.end")
            //                    }
            //                }
        }
    }
}

class LivePhotosUtil {
    
    static func save(livePhotoAsset asset: PHAsset) {
        doViaLivePhotoSource(livePhotoAsset: asset, imageHandler: nil)
    }
    
    static func doViaLivePhotoSource(livePhotoAsset asset: PHAsset, imageHandler: ((UIImage) -> Void)?) {
        guard asset.mediaSubtypes.contains(.photoLive) else {
            DLog("\(asset) 不是Live Photo")
            return
        }
        
        let arr = PHAssetResource.assetResources(for: asset)
        
        DLog(arr)
        
        PHAssetResourceManager.default().requestData(for: arr[0], options: nil, dataReceivedHandler: { (data) in
            let _image = UIImage(data: data)
            guard let image = _image else {
                return
            }
            imageHandler?(image)
        }) { (error) in
            DLog(error?.localizedDescription ?? "no errer")
        }
        
        AssetsUtils.saveAssetResource(resource: arr[1], inDirectory: AssetsUtils.generateTemporaryDirectory(), buffer: nil, maybeError: nil) { (url) in
            AssetsUtils.saveVideo(atFileURL: url)
        }
    }
    
    private static func doViaLivePhoto(livePhotoAsset asset: PHAsset, do callback: @escaping (PHLivePhoto?, [AnyHashable : Any]?) -> Swift.Void) {
        guard !asset.mediaSubtypes.contains(.photoLive) else {
            return
        }
        let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        PHImageManager.default().requestLivePhoto(
            for: asset,
            targetSize: size,
            contentMode: .aspectFit,
            options: nil
        ){
            (livePhoto, info) in
            guard livePhoto != nil else { return }
            callback(livePhoto, info)
        }
    }
}
