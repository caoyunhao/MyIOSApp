//
//  AssetsUtils.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/11.
//  Copyright © 2018 Yunhao. All rights reserved.
//
import UIKit
import Photos
import MobileCoreServices

class AssetsUtils {
    
    static func move(assets: [PHAsset], titleOfTargetAlbum albumTitle: String, delete: Bool) {
        
        doInAlbum(title: albumTitle) { album in
            PHPhotoLibrary.shared().performChanges({
//                let addRequest = PHAssetCollectionChangeRequest.init(for: album)
                assets.forEach({ (asset) in
                    let re = PHAssetChangeRequest(for: asset)
                    re.creationDate = nil
                })
//                addRequest?.addAssets(assets as NSFastEnumeration)
            }, completionHandler: { (success, error) in
                DLog("Callback success: \(success)")
                if delete {
                    DLog("delete")
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.deleteAssets(assets as NSFastEnumeration)
                    }) { (success, error) in
                        DLog("delete Callback success: \(success)")
                    }
                }
            })
        }
    }
    
    static func save(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    static func save(image: UIImage, titleOfToAblum title: String) {
        doInAlbum(title: title) { (ablum) in
            PHPhotoLibrary.shared().performChanges({
                let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let assetPlaceholder = assetRequest.placeholderForCreatedAsset
                let albumChangeRequest = PHAssetCollectionChangeRequest.init(for: ablum)
                albumChangeRequest?.addAssets([assetPlaceholder!] as NSArray)
                
            }) { (success, error) in
                DLog("Save image success: \(success)")
            }
        }
    }
    
    static func save(image: UIImage, completion: @escaping (_ localIdentifier: String) -> Void) {
        var localIdentifier: String?
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            //保存标志符
            localIdentifier = request.placeholderForCreatedAsset?.localIdentifier
        }) { (success: Bool, error: Error?) in
            if success, let localIdentifier = localIdentifier {
                DLog("保存成功! (\(localIdentifier)")
                completion(localIdentifier)
            }
        }
    }
    
    static func saveImage(atFileURL fileURL: URL, completion: @escaping (Bool, Error?) -> ()) {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
            request?.creationDate = Date()
        }) { (success, error) in
            if success {
                DLog("save asset success.")
                completion(success, error)
            } else {
                DLog("save asset failure.")
                completion(success, error)
            }
        }
    }
    
    static func saveVideo(atFileURL fileURL: URL) {
//        PHPhotoLibrary.shared().performChanges({
//            let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
//            request?.creationDate = Date()
//        }) { (success, error) in
//            if success {
//                DLog("save asset success. (\(fileURL))")
//            } else {
//                DLog("save asset failure. (\(fileURL)), \(error?.localizedDescription)")
//            }
//        }
        
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
//                let options = PHAssetResourceCreationOptions()
//                options.shouldMoveFile = true
//                let request = PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
//                request?.addResource(with: .video, fileURL: fileURL, options: options)
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
            }
            DLog("save asset success. (\(fileURL))")
        } catch (let error) {
            DLog("save asset failure. (\(fileURL)), \(error.localizedDescription)")
        }
        
            
//        }) { (success, error) in
//            if success {
//                DLog("save asset success. (\(fileURL))")
//            } else {
//                DLog("save asset failure. (\(fileURL)), \(error?.localizedDescription)")
//            }
//        }
    }
    
    static func generateTemporaryDirectory() -> NSURL {
        let dir = NSURL(
            // NB: Files in NSTemporaryDirectory() are automatically cleaned up by the OS
            fileURLWithPath: NSTemporaryDirectory(),
            isDirectory: true
            ).appendingPathComponent(UUID().uuidString, isDirectory: true)
        
        let fileManager = FileManager()
        // we need to specify type as ()? as otherwise the compiler generates a warning
        let _ : ()? = try? fileManager.createDirectory(
            at: dir!,
            withIntermediateDirectories: true,
            attributes: nil
        )
        
//        return success != nil ? photoDir! as NSURL : nil
        return dir! as NSURL
    }
    
    static func generateTemporaryFile() -> NSURL {
        return generateTemporaryDirectory().appendingPathComponent(UUID().uuidString, isDirectory: false)! as NSURL
    }
    
    static func saveAssetResource(
        resource: PHAssetResource,
        inDirectory: NSURL,
        buffer: NSMutableData?,
        maybeError: Error?,
        callback: ((URL) -> Void)?
        ) -> Void {
        
        DLog("start")
        
        guard maybeError == nil else {
            DLog("Could not request data for resource: \(resource), error: \(String(describing: maybeError))")
            return
        }
        
        let maybeExt = UTTypeCopyPreferredTagWithClass(
            resource.uniformTypeIdentifier as CFString,
            kUTTagClassFilenameExtension
            )?.takeRetainedValue()
        
        guard let ext = maybeExt else {
            return
        }
        
        guard var fileUrl = inDirectory.appendingPathComponent(NSUUID().uuidString) else {
            DLog("file url error")
            return
        }
        
        fileUrl = fileUrl.appendingPathExtension(ext as String)
        
        if let buffer = buffer, buffer.write(to: fileUrl, atomically: true) {
            DLog("Saved resource form buffer \(resource) to filepath \(String(describing: fileUrl))")
            callback?(fileUrl)
        } else {
            PHAssetResourceManager.default().writeData(for: resource, toFile: fileUrl, options: nil) { (error) in
                DLog("Saved resource directly \(resource) to filepath \(String(describing: fileUrl))")
                callback?(fileUrl)
            }
        }
        DLog("end")
    }
    
    fileprivate static func imageFrom(asset: PHAsset) -> UIImage {
        PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: {
            (data, string, imageOrientation, map) in
            DLog(data)
            DLog(string)
            DLog(imageOrientation)
            DLog(map)
        })
        
        var image: UIImage!
        
        let imageRequestOption = PHImageRequestOptions()
        imageRequestOption.isSynchronous = true
        imageRequestOption.resizeMode = .none
        imageRequestOption.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
            contentMode: .aspectFill,
            options: imageRequestOption,
            resultHandler: {
                (result, _) in
                image = result!
        })
        return image
    }
    
    fileprivate static func doInAlbum(title: String, callback:@escaping (PHAssetCollection)->Void) {
        DLog("title: \(title)")
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate.init(format: "title=%@", title)
        let collection: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        DLog(collection)
        
        if let ret = collection.firstObject{
            callback(ret)
        } else {
            var assetCollectionPlaceholder:PHObjectPlaceholder!
            PHPhotoLibrary.shared().performChanges({
                let creatAlbumRequest:PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                assetCollectionPlaceholder = creatAlbumRequest.placeholderForCreatedAssetCollection
            }) { (success, error) in
                DLog("getAlbum success: \(success)")
                if success {
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [assetCollectionPlaceholder.localIdentifier], options: nil)
                    callback(collectionFetchResult.firstObject!)
                }
            }
        }
    }
    
    static func handleImageData(of asset: PHAsset, handler: @escaping (_ data: Data) -> Void) {
        let options = PHImageRequestOptions()
        options.version = .current
        DLog("asset: \(asset.cyhDescriptionFormatted)")
        PHImageManager.default().requestImageData(for: asset, options: options) {
            data, uti, orientation, info in
            DLog(info)
            DLog("asset.location \(String(describing: asset.location))")
            guard let data = data else {
                return
            }
            handler(data)
        }
    }
    
    static func handleImageDataSynchronous(of asset: PHAsset, handler: @escaping (_ data: Data) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.version = .current
        DLog("asset: \(asset.cyhDescriptionFormatted)")
        PHImageManager.default().requestImageData(for: asset, options: options) {
            data, uti, orientation, info in
            DLog(info)
            DLog("asset.location \(String(describing: asset.location))")
            guard let data = data else {
                return
            }
            handler(data)
        }
    }
    
    static func getAVAsset(forVideo asset: PHAsset, handle: @escaping (AVAsset) -> ()) {
        let option = PHVideoRequestOptions()
        option.version = .current
        option.deliveryMode = .automatic
        option.isNetworkAccessAllowed = false
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: option) { (avAsset, audio, map) in
            guard let avAsset = avAsset else {
                DLog("avAsset == nil")
                return
            }
            
            handle(avAsset);
        }
    }
}
