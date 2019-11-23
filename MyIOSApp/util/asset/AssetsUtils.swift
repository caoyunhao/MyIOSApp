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
    
    static func move(placeholders: [PHObjectPlaceholder], titleOfTargetAlbum albumTitle: String, delete: Bool) {
        let localIdentifiers = placeholders.map({ (holder) -> String in
            return holder.localIdentifier
        })
        move(localIdentifiers: localIdentifiers, titleOfTargetAlbum: albumTitle, delete: delete)
    }
    
    static func move(localIdentifiers: [String], titleOfTargetAlbum albumTitle: String, delete: Bool) {
        let assetsResult = PHAsset.fetchAssets(withLocalIdentifiers: localIdentifiers, options: nil)
        var assets = [PHAsset]()
        assetsResult.enumerateObjects { (asset, index, _) in
            assets.append(asset)
        }
        move(assets: assets, titleOfTargetAlbum: albumTitle, delete: delete)
    }
    
    static func move(assets: [PHAsset], titleOfTargetAlbum albumTitle: String, delete: Bool) {
        guard let album = getAlbumCreatingIfNotExist(title: albumTitle) else {
            return
        }
        let signal = DispatchSemaphore(value: 0)
        DispatchQueue.main.async {
            PHPhotoLibrary.shared().performChanges({
                if let addRequest = PHAssetCollectionChangeRequest(for: album) {
                    assets.forEach({ (asset) in
                        let re = PHAssetChangeRequest(for: asset)
                        re.creationDate = nil
                    })
                    addRequest.addAssets(assets as NSFastEnumeration)
                } else {
                    DLog("PHAssetCollectionChangeRequest fail")
                }
            }, completionHandler: { (success, error) in
                DLog("move callback success: \(success)")
                if delete {
                    DLog("delete")
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.deleteAssets(assets as NSFastEnumeration)
                    }) { (success, error) in
                        DLog("delete Callback success: \(success)")
                        signal.signal()
                    }
                } else {
                    signal.signal()
                }
            })
        }
        
        signal.wait()
    }
    

    
    static func save(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    static func save(image: UIImage, titleOfToAblum title: String) {
        guard let ablum = getAlbumCreatingIfNotExist(title: title) else {
            return
        }
        PHPhotoLibrary.shared().performChanges({
            let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceholder = assetRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: ablum)
            albumChangeRequest?.addAssets([assetPlaceholder!] as NSArray)
        }) { (success, error) in
            DLog("Save image success: \(success)")
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
        PHPhotoLibrary.shared().performChanges( {
//                let options = PHAssetResourceCreationOptions()
//                options.shouldMoveFile = true
//                let request = PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
//                request?.addResource(with: .video, fileURL: fileURL, options: options)
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
        }) { success, error in
            if success {
                DLog("save asset success. (\(fileURL))")
            } else {
                DLog("save asset failure. (\(fileURL)), \(error?.localizedDescription)")
            }
        }
    }
    
    static func saveToLibraySync(fromFileURL fileURL: URL, mediaType: PHAssetMediaType, toAlbum: String? = nil) -> PHObjectPlaceholder? {
//        guard FileManager.default.fileExists(atPath: fileURL.absoluteString) else {
//            DLog("No file at \(fileURL)")
//            return nil
//        }
        
        let signal = DispatchSemaphore(value: 0)
        var holder: PHObjectPlaceholder?
        
        PHPhotoLibrary.shared().performChanges( {
            if mediaType == .image {
                holder = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)?.placeholderForCreatedAsset
            }
            if mediaType == .video {
                holder = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)?.placeholderForCreatedAsset
            }
            if let holder = holder, let title = toAlbum, let album = getAlbumCreatingIfNotExist(title: title) {
                let req = PHAssetCollectionChangeRequest(for: album)
                req?.addAssets([holder] as NSFastEnumeration)
            }
        }) { success, error in
            if success {
                DLog("save asset success. (\(fileURL))")
            } else {
                DLog("save asset failed. \(error)")
            }
            signal.signal()
        }
        signal.wait()
        
        return holder
    }
    
    static func generateTemporaryDirectory() -> URL {
        let dir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        if let _ = try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil) {
//            DLog("generateTemporaryDirectory success \(dir)")
        } else {
            DLog("generateTemporaryDirectory failed \(dir)")
        }
        return dir
    }
    
    static func generateTemporaryFile() -> URL {
        return generateTemporaryDirectory().appendingPathComponent(UUID().uuidString, isDirectory: false)
    }
    
    static func saveAssetResourceToFileSync(resource: PHAssetResource, fileUrl: URL) -> URL? {        
        DLog("saveAssetResourceToFileSync start \(resource.type)")
    
        guard let ext = UTTypeCopyPreferredTagWithClass(
                    resource.uniformTypeIdentifier as CFString,
                    kUTTagClassFilenameExtension
                    )?.takeRetainedValue() else {
            return nil
        }
        
        let file = fileUrl.appendingPathExtension(ext as String)
        
        
        let signal = DispatchSemaphore(value: 0)
    
        var hasError = false
        PHAssetResourceManager.default().writeData(for: resource, toFile: file, options: nil) { (error) in
            if let error = error {
                DLog("Save resource \(resource.originalFilename) to filepath \(String(describing: file)) failed \(error.localizedDescription)")
                hasError = true
            } else {
                DLog("Save resource \(resource.originalFilename) to filepath \(String(describing: file)) success")
            }
            signal.signal()
        }
        
        
        signal.wait()
        
        DLog("saveAssetResourceToFileSync end")
        
        return hasError ? nil: file
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
    
    fileprivate static func getAlbumCreatingIfNotExist(title: String) -> PHAssetCollection? {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title=%@", title)
        let collection: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        
        if let ret = collection.firstObject{
            return ret
        } else {
            DLog("\(title) is not existed. create")
            // 创建相册
            let signal = DispatchSemaphore(value: 0)
            var coll: PHAssetCollection?
            var h:PHObjectPlaceholder?
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                h = request.placeholderForCreatedAssetCollection
            }) { (success, error) in
                if success, let re =  PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [h!.localIdentifier], options: nil).firstObject {
                    coll = re
                } else {
                    DLog("getAlbum failed: \(String(describing: error))")
                }
                signal.signal()
            }
            signal.wait()
            return coll
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
