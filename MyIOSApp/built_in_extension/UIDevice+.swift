//
//  UIDevice+.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/12/30.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

extension UIDevice{
    
    fileprivate func blankof<T>(type:T.Type) -> T {
        let ptr = UnsafeMutablePointer<T>.allocate(capacity: MemoryLayout<T>.size)
        let val = ptr.pointee
        ptr.deinitialize(count: Int.max)
        return val
    }
    
    /// 磁盘总大小
    var totalDisk: Int64{
        var fs = blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return Int64(UInt64(fs.f_bsize) * fs.f_blocks)
        }
        return -1
    }
    
    /// 磁盘可用大小
    var availableDisk: Int64{
        var fs = blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return Int64(UInt64(fs.f_bsize) * fs.f_bavail)
        }
        return -1
    }
    
    var totalRAM: Int64 {
        return Int64(ProcessInfo.processInfo.physicalMemory)
    }
    
    /// 获取当前可用内存
    var availableRAM: Int64 {
        var fs = blankof(type: statfs.self)
        if statfs("/var",&fs) >= 0{
            return Int64(UInt64(fs.f_bsize) * fs.f_bavail)
        }
        return -1
    }
    
    func deviceName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1":                               return "iPhone 7 (CDMA)"
        case "iPhone9,3":                               return "iPhone 7 (GSM)"
        case "iPhone9,2":                               return "iPhone 7 Plus (CDMA)"
        case "iPhone9,4":                               return "iPhone 7 Plus (GSM)"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    /// 将大小转换成字符串用以显示
    static func fileSizeString(fileSize:Int64) -> String{
        
        let fileSize1 = CGFloat(fileSize)
        
        let KB:CGFloat = 1024
        let MB:CGFloat = KB*KB
        let GB:CGFloat = MB*KB
        
        if fileSize < 10 {
            return "0 B"
            
        } else if fileSize1 < KB {
            return "< 1 KB"
        } else if fileSize1 < MB {
            return String(format: "%.1f KB", CGFloat(fileSize1)/KB)
        } else if fileSize1 < GB {
            return String(format: "%.1f MB", CGFloat(fileSize1)/MB)
        } else {
            return String(format: "%.1f GB", CGFloat(fileSize1)/GB)
        }
    }
}
