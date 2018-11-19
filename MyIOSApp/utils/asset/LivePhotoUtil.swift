//
//  LivePhotoUtil.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/18.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation
import Photos

class LivePhotosUtil {
    
    static func save(livePhotoAsset asset: PHAsset) {
        doViaLivePhotoSource(livePhotoAsset: asset, imageHandler: nil)
    }
    
    static func doViaLivePhotoSource(livePhotoAsset asset: PHAsset, imageHandler: ((UIImage) -> Void)?) {
        guard asset.mediaSubtypes.contains(.photoLive) else {
            DLog(message: "\(asset) 不是Live Photo")
            return
        }
        
        let arr = PHAssetResource.assetResources(for: asset)
        
        DLog(message: arr)
        
        PHAssetResourceManager.default().requestData(for: arr[0], options: nil, dataReceivedHandler: { (data) in
            let _image = UIImage(data: data)
            guard let image = _image else {
                return
            }
            imageHandler?(image)
        }) { (error) in
            DLog(message: error?.localizedDescription ?? "no errer")
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
