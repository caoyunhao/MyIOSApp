//
//  serialization.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/9/4.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

class Serialization {
    static func json(withData data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options:[])
        }catch let error as NSError{
            DLog(message: "解析出错。\(error.localizedDescription)")
            return nil
        }
    }
    
    static func json(jsonStr: String) -> Any? {
        return json(withData: jsonStr.data(using: .utf8)!)
    }
    
    static func json(fileName: String, type: String) -> Any? {
        let path = Bundle.main.path(forResource: fileName, ofType: type);
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            return json(withData: data)
        } catch _ as Error? {
            return nil;
        }
    }
}
