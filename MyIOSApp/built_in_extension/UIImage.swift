//
//  UIImage.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/27.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

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
    
    public var ratio: Float {
        return Float(size.width / size.height)
    }
    /**
     *  重设图片大小
     */
    func e_resize(size: CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
     *  等比率缩放
     */
    func myScale(scaleSize: CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return e_resize(size: reSize)
    }
    
    func myData() -> Data? {
        return UIImageJPEGRepresentation(self, 1.0)
    }
    
    func dataSize() -> Int {
        return (self.myData()?.count)!
    }
    
    func optimizeStoreSize() {
        DLog(message: "原大小：\(self.dataSize()) KB")
        var rate: Float = 0.9
        while (rate > 0) {
            UIImageJPEGRepresentation(self, CGFloat(rate))
            rate -= 0.1
        }
        DLog(message: "新大小：\(self.dataSize()) KB")
    }
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
            
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
        
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        
        return img
    }
    
    func e_rotateLeft90() -> UIImage {
        let image = self.fixOrientation()
        
        let targetSize = CGSize(width: image.size.height, height: image.size.width)
//        let targetSize = self.size
        let rect = CGRect(origin: CGPoint.zero, size: targetSize)
        let drawRect = CGRect(origin: CGPoint.zero, size: self.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.clip(to: rect)
        
        // 左转
        currentContext?.scaleBy(x: 1, y: -1)
        currentContext?.rotate(by: CGFloat(Double.pi / 2))
        currentContext?.translateBy(x: -targetSize.height, y: -targetSize.width)
        // 右转
//        currentContext?.scaleBy(x: 1, y: -1)
//        currentContext?.rotate(by: -CGFloat(Double.pi / 2))
        
        
        currentContext?.draw(image.cgImage!, in: drawRect)
//        currentContext?.rotate(by: CGFloat(Double.pi / 2))

        let drawImage = UIGraphicsGetImageFromCurrentImageContext();//获得图片
        UIGraphicsEndImageContext()
        DLog(message: image.imageOrientation.rawValue)
        let flipImage = UIImage(cgImage:drawImage!.cgImage!, scale: 1, orientation: .up)
        
        return flipImage
    }
}
