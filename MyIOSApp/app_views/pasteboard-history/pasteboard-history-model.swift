//
//  pastboard-history-manager.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/8/5.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class PasteboardHistoryManager {
    
    static let `default` = PasteboardHistoryManager()
    
    func insertCurrent() {
        let pb =  UIPasteboard.general
        if let text = pb.string {
            insert(string: text)
        }
        if let image = pb.image {
            insert(image: image)
        }
    }
    
    func getAll() -> [PasteboardHistoryItem] {
        return PastboardHistoryDB.default.queryAll()
    }
    
    func insert(string: String) {
        if PastboardHistoryDB.default.insert(text: string, textMd5: string.md5) {
            DLog("insert text success")
        } else {
            DLog("insert text fail")
        }
    }
    
    func insert(image: UIImage) {
        if let data = image.pngData {
            let md5 = data.md5
            guard PastboardHistoryDB.default.query(byImageMD5: md5) == nil else {
                DLog("insert image fail. Existed \(md5)")
                return
            }
            
//            UserDefaults.standard.set(data, forKey: md5)
            if PastboardHistoryDB.default.insert(imageMD5: md5) {
                DLog("insert image success")
            } else {
                UserDefaults.standard.removeObject(forKey: md5)
                DLog("insert image fail")
            }
        }
    }
    
    func delete(item: PasteboardHistoryItem) {
        if let id = item.id {
            if PastboardHistoryDB.default.delete(byId: id) {
                DLog("delete \(id) success")
            } else {
                DLog("delete \(id) fail")
            }
        } else {
            DLog("no id")
        }
        
        if let imageId = item.imageId {
            UserDefaults.standard.removeObject(forKey: imageId)
        }
    }
}
