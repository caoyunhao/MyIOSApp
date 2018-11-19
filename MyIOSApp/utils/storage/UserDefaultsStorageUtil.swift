//
//  UserDefaultsStorageUtil.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/24.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

class UserDefaultsStorageUtil {
    
    static func put(dictionaryName name: String, key: String, object: BaseStorage) {
        let uuid = save(object: object)
        let dict = UserDefaults.standard.dictionary(forKey: name)
        if var dict = dict {
            dict[name] = uuid
            UserDefaults.standard.set(dict, forKey: name)
        }
    }
    
    static func object(dictionaryName name: String, key: String) -> Any? {
        let container = UserDefaults.standard.dictionary(forKey: name)
        if var container = container {
            let uuid = container[key]
            return getObject(forKey: uuid as! String)
        }
        
        return nil
    }
    
    /**
     * array
     */
    static func getArray(name: String) -> [Any]? {
        return UserDefaults.standard.array(forKey: name)
    }
    
    static func appendObject(arrayName: String, value: BaseStorage) {
        let container = UserDefaults.standard.array(forKey: arrayName) as? [String]
        
        if var container = container {
            container.append(save(object: value))
            UserDefaults.standard.set(container, forKey: arrayName)
        } else {
            let newContainer: [String]  = [save(object: value), ]
            UserDefaults.standard.set(newContainer, forKey: arrayName)
        }
    }
    
    static func remove(arrayName: String, key: String) {
        let container = UserDefaults.standard.array(forKey: arrayName)
        if var container = container {
            container.remove(at: container.index(where: { (item) -> Bool in
                return item as! String == key
            })!)
            UserDefaults.standard.set(container, forKey: arrayName)
        }
    }
    
    static func has(arrayName: String, key: String) -> Bool {
        let container = UserDefaults.standard.array(forKey: arrayName)
        if let container = container {
            for item in container {
                if (item as? String) == key {
                    return true
                }
            }
        }
        return false
    }
    
    /**
     * base
     */
    static func save(baseObject: Any) -> String {
        let uuid = UUID().uuidString;
        UserDefaults.standard.set(baseObject, forKey: uuid)
        return uuid
    }
    
    static func save(object: BaseStorage, key: String? = nil) -> String {
        let key = key ?? object.id;
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: object), forKey: key)
        return key
    }
    
    static func getObject(forKey key: String) -> Any? {
        let data = UserDefaults.standard.object(forKey: key)
        if let data = data {
            return NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
        } else {
            return nil
        }
    }
    
    static func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func clean(arrayName: String, includeItem: Bool = true) {
        if let array = getArray(name: arrayName) {
            array.forEach { (itemName) in
                UserDefaults.standard.removeObject(forKey: itemName as! String)
            }
            UserDefaults.standard.removeObject(forKey: arrayName)
        }
    }
    
    static func cleanAll() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}
