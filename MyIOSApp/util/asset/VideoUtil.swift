//
//  VideoUtil.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/11/6.
//  Copyright © 2018 Yunhao. All rights reserved.
//

#if os(iOS)
import UIKit
import MobileCoreServices
#elseif os(OSX)
import AppKit
#endif

import ImageIO
import AVFoundation

class VideoUtil {
    
    fileprivate static let gifCFStr = "com.compuserve.gif" as CFString
    
    struct Video2GifRequest {
        let asset: AVAsset
        let savePath: URL
        let framesPreSecond: Int
    }
    
    static func convertToGif(request: Video2GifRequest, processRate: ((Float) -> ())?, completion: @escaping (URL) -> ()) {
        
        //        let framesPreSecond = request.framesPreSecond
        //        let duration: Float = 1.0 / Float(framesPreSecond)
        
        DLog(message: "path : \(request.savePath.absoluteString)")
        
        let assetImageGenerator = AVAssetImageGenerator(asset: request.asset)
        assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero
        assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.apertureMode = .encodedPixels
        
        let cmTimeDuration = assetImageGenerator.asset.duration as CMTime
        let cmTimeTotal = cmTimeDuration.seconds
        var cmTimeCurrent: Double = 0.0
        
        let delaySecPerFrame = max(Double(cmTimeDuration.timescale) / 1_000_000.0, 1.0 / Double(request.framesPreSecond))
        
        let frameCount = Int(cmTimeTotal / delaySecPerFrame)
        
        DLog(message: "cmTimeTotal: \(cmTimeTotal)")
        DLog(message: "delaySecPerFrame: \(delaySecPerFrame)")
        DLog(message: "frameCount: \(frameCount)")
        
        guard let destination = CGImageDestinationCreateWithURL(request.savePath as CFURL, gifCFStr, frameCount, nil) else {
            return
        }
        
        let frameProperties = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFDelayTime as String: delaySecPerFrame,
            ],
            ] as CFDictionary
        let gifProperties = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFLoopCount as String: 0,
            ],
            ] as CFDictionary
        
        CGImageDestinationSetProperties(destination, gifProperties) //保存gif图像
        
        DLog(message: "timescale: \(cmTimeDuration.timescale)")
        
        for i in 0..<frameCount {
            processRate?(Float(i) / Float(frameCount))
            
            if cmTimeCurrent > cmTimeTotal {
                break
            }
            
            // let tmpTime = CMTimeMakeWithSeconds(cmTimeCurrent, cmTimeDuration.timescale)
            let tmpTime = CMTimeMakeWithSeconds(cmTimeCurrent, cmTimeDuration.timescale)
            
            DLog(message: "tmpTime: \(tmpTime)")
            DLog(message: "cmTimeCurrent: \(cmTimeCurrent)")
            
            let cgImage = try? assetImageGenerator.copyCGImage(at: tmpTime, actualTime: nil)
            
            let image = UIImage(cgImage: cgImage!)
            
            cmTimeCurrent += Double(delaySecPerFrame)
            
            // 帧图片存入到destination
            
            CGImageDestinationAddImage(destination, image.cgImage! , frameProperties)
        }
        
        processRate?(1.0)
        
        let flag = CGImageDestinationFinalize(destination)
        // destination = nil
        
        DLog(message: flag)
        
        completion(request.savePath)
    }
}
