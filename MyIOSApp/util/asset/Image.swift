//
//  Image.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/30.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad() // Do any additional setup after loading the view, typically from a nib. managerVideoToGif(frequency:5)
    }
    func managerVideoToGif(frequency:Int){ //图片转GIF配置
        let myDirectory: String = NSHomeDirectory() + "/Documents"
        let path: String = myDirectory + "/my.gif"
        let pathUrl = URL.init(fileURLWithPath: path)
        let cfPath = pathUrl as CFURL
        let cfStr = "com.compuserve.gif" as CFString
        
        let frameProperties = NSDictionary.init(object: NSDictionary(object: 0.2, forKey: kCGImagePropertyGIFDelayTime as NSString), forKey: kCGImagePropertyGIFDictionary as NSString)
        let gifProperties = NSDictionary.init(object: NSDictionary(object: 1, forKey: kCGImagePropertyGIFLoopCount as NSString), forKey: kCGImagePropertyGIFDictionary as NSString)
        
        var destination = CGImageDestinationCreateWithURL(cfPath, cfStr, Int.max, nil) //视频中提取帧图片
        
        let asset = AVURLAsset.init(url: URL.init(fileURLWithPath: "/Users/caoyunhao/Desktop/Reduce_Transparency.mp4"))
        
        let assetImageGenerator = AVAssetImageGenerator.init(asset: asset)
        
        assetImageGenerator.appliesPreferredTrackTransform = true
        assetImageGenerator.apertureMode = .encodedPixels
        
        let cmTimeDuration = assetImageGenerator.asset.duration as CMTime
        let cmTimeSecond = Int(cmTimeDuration.seconds)
        var cmTimeCurrent:Float64 = 0
        for _ in 0..<Int.max {
            if cmTimeCurrent >= Float64(cmTimeSecond){
                break
            }
            let tmpTime = CMTimeMakeWithSeconds(cmTimeCurrent, cmTimeDuration.timescale)
            
            let cgImage = try? assetImageGenerator.copyCGImage(at: tmpTime, actualTime: nil)
            
            let image = UIImage.init(cgImage: cgImage!)
            
            cmTimeCurrent += Float64(1)
            DLog(tmpTime) //帧图片存入到destination
            CGImageDestinationAddImage(destination!, image.cgImage! , frameProperties)
            CGImageDestinationSetProperties(destination!, gifProperties) //保存gif图像
            let flag = CGImageDestinationFinalize(destination!)
            destination = nil
            DLog(path)
            DLog(flag)
        }
    }
        
        /* func saveToFile(image:UIImage,index:Int){
         let myDirectory:String = NSHomeDirectory() + "/Documents" l
         et path:String = myDirectory + "//(index).png"
         DLog(path)
         let data = UIImagePNGRepresentation(image) as NSData?
         data?.write(toFile: path, atomically: true) }
         
         func saveToGif(images:Array<UIImage>){
         let myDirectory:String = NSHomeDirectory() + "/Documents"
         let path:String = myDirectory + "/my.gif"
         let pathUrl = URL.init(fileURLWithPath: path)
         let cfPath = pathUrl as CFURL
         let cfStr = "com.compuserve.gif" as CFString
         var destination = CGImageDestinationCreateWithURL(cfPath,cfStr, images.count, nil)
         let frameProperties = NSDictionary.init(object: NSDictionary(object: 0.2, forKey: kCGImagePropertyGIFDelayTime as NSString), forKey: kCGImagePropertyGIFDictionary as NSString)
         let gifProperties = NSDictionary.init(object: NSDictionary(object: 1, forKey: kCGImagePropertyGIFLoopCount as NSString), forKey: kCGImagePropertyGIFDictionary as NSString)
         for image in images {
         CGImageDestinationAddImage(destination!, image.cgImage! , frameProperties)
         }
         CGImageDestinationSetProperties(destination!, gifProperties)
         let flag = CGImageDestinationFinalize(destination!)
         destination = nil
         DLog(path)
         DLog(flag) }
         */
}
