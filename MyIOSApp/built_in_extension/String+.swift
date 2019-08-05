//
//  String+.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/9/6.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

extension String {
    var md5: String {
        let cStr = cString(using: String.Encoding.utf8);
        let buffer = Swift.UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    var valid: String? {
        let string = trimmingCharacters(in: .whitespacesAndNewlines)
        if string != "" {
            return string
        }
        return nil
    }
}
