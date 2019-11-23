//
//  LivePhotoUtil.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/18.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
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
            
            let output = AssetsUtils.generateTemporaryDirectory().path
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
    
    static func saveLivePhotoToFile(livePhotoAsset asset: PHAsset, mediaTypes: [PHAssetMediaType]) -> (URL?, URL?)? {
        guard asset.mediaSubtypes.contains(.photoLive) else {
            DLog("\(asset) 不是Live Photo")
            return nil
        }
        
        let arr = PHAssetResource.assetResources(for: asset)
        
        var fileUrl1: URL? = nil
        var fileUrl2: URL? = nil
        
        var currentVideo: PHAssetResource? = nil
        var originVideo: PHAssetResource? = nil
        
        for res in arr {
            DLog("resource type \(res.type.rawValue)")
            if fileUrl1 == nil, mediaTypes.contains(.image) && res.type == .photo {
                fileUrl1 = AssetsUtils.saveAssetResourceToFileSync(resource: res, fileUrl: AssetsUtils.generateTemporaryFile() as URL)
            }
            
            if mediaTypes.contains(.video) {
                switch res.type {
                case .pairedVideo:
                    originVideo = res
                case .fullSizePairedVideo:
                    currentVideo = res
                default:
                    break
                }
            }
        }
        
        if let currentVideo = currentVideo {
            DLog("save current video")
            fileUrl2 = AssetsUtils.saveAssetResourceToFileSync(resource: currentVideo, fileUrl: AssetsUtils.generateTemporaryFile())
        }
        if let originVideo = originVideo, fileUrl2 == nil {
            DLog("save origin video")
            fileUrl2 = AssetsUtils.saveAssetResourceToFileSync(resource: originVideo, fileUrl: AssetsUtils.generateTemporaryFile())
        }
        
        return (fileUrl1, fileUrl2)
    }
    
    static func saveLivePhotoToLibray(livePhotoAsset asset: PHAsset, mediaTypes: [PHAssetMediaType], toAlbum: String? = nil) -> (PHObjectPlaceholder?, PHObjectPlaceholder?) {
        let paths = saveLivePhotoToFile(livePhotoAsset: asset, mediaTypes: mediaTypes);
        var h1: PHObjectPlaceholder?
        var h2: PHObjectPlaceholder?
        DLog(paths)
        if let path = paths!.0 {
            h1 = AssetsUtils.saveToLibraySync(fromFileURL: path, mediaType: .image, toAlbum: toAlbum)
        }
        if let path = paths!.1 {
            h2 = AssetsUtils.saveToLibraySync(fromFileURL: path, mediaType: .video, toAlbum: toAlbum)
        }
        
        return (h1, h2)
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
