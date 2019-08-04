//
//  contacts.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/26.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation
import Contacts



class ContactsHelper: NSObject {
    static let shared: ContactsHelper = ContactsHelper()
    
    var keysToFetch: [String] {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneticGivenNameKey, CNContactPhoneticFamilyNameKey]
        return keys
    }
    
    lazy var contactStore: CNContactStore = {
        let cn:CNContactStore = CNContactStore()
        return cn
    }()
    
    func requestContactStoreAuthorization() {
        self.contactStore.requestAccess(for: .contacts, completionHandler: {(granted, error) in
            if granted {
                DLog("已授权")
            }
        })
    }
    
    lazy var locationInfo:[String: String] = {
        return Serialization.json(fileName: "mobile_location", type: "json") as! [String: String]
    }()
    
    func checkContactStoreAuth(){
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined:
            DLog("未授权")
            requestContactStoreAuthorization()
        case .authorized:
            DLog("已授权")
        case .denied, .restricted:
            DLog("无权限")
            //可以选择弹窗到系统设置中去开启
        }
    }
    
    func enumerateContacts(processing: ((CNMutableContact, Int, Int) -> ())? = nil, completeHandler: (() -> ())? = nil) {
        checkContactStoreAuth()
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else {
            return
        }
        
        guard let contactList = contactList() else {
            return
        }
        DispatchQueue.global().async {
            let count = contactList.count
            for (index, contact) in contactList.enumerated() {
                if !contact.familyName.isEmpty || !contact.givenName.isEmpty {
                    
                    let mutableContact = contact.mutableCopy() as! CNMutableContact
                    processing?(mutableContact, index, count)
                    
                    self.saveContact(mutableContact)
                }
            }
            DispatchQueue.main.async {
                completeHandler?()
            }
        }
    }

    func addPhoneticAndSave(_ mutableContact: CNMutableContact) {
        var phoneticFamilyResult = ""
        var phoneticGivenResult  = ""
        // var phoneticFamilyBrief  = ""
        // var phoneticGivenBrief   = ""
        
        
        if let family = mutableContact.value(forKey: CNContactFamilyNameKey) as? String {
            if self.antiPhonetic(family) {
                let cffamily = NSMutableString(string: family) as CFMutableString
                DLog("\(cffamily)")
                CFStringTransform(cffamily, nil, kCFStringTransformMandarinLatin, false)
                DLog("\(cffamily)")
                phoneticFamilyResult = ((cffamily as NSString).capitalized) as String
            }
        }
        
        if let given = mutableContact.value(forKey: CNContactGivenNameKey) as? String {
            if self.antiPhonetic(given) {
                let cfGiven = NSMutableString(string: given) as CFMutableString
                DLog("\(cfGiven)")
                CFStringTransform(cfGiven, nil, kCFStringTransformMandarinLatin, false)
                DLog("\(cfGiven)")
                phoneticGivenResult = ((cfGiven as NSString).capitalized) as String
            }
        }
        
        mutableContact.setValue(phoneticFamilyResult, forKey: CNContactPhoneticFamilyNameKey)
        mutableContact.setValue(phoneticGivenResult, forKey: CNContactPhoneticGivenNameKey)
    }

    func addCallerlocAndSave(_ mutableContact: CNMutableContact) {
//        var newElements: [CNLabeledValue<CNPhoneNumber>] = []
//        for labeledValue in mutableContact.phoneNumbers {
//            let originPhoneNumber = (labeledValue.value as CNPhoneNumber).stringValue
//            let phoneNumber = originPhoneNumber
//                .replacingOccurrences(of: " ", with: "")
//                .replacingOccurrences(of: "-", with: "")
//                .replacingOccurrences(of: "\u{00A0}", with: "")
//
//            if let item = self.locationInfo[phoneNumber.prefix(7).description] {
//                let province_city = item.split(separator: "-")
//                let province = province_city[0].description
//                let city = province_city[1].description
//                DLog( (province, city))
//                newElements.append(labeledValue.settingLabel("\(province) - \(city)"))
//            } else {
//                newElements.append(labeledValue)
//            }
//        }
//        mutableContact.setValue(newElements, forKey: CNContactPhoneNumbersKey)
    }
    
    private func antiPhonetic(_ str: String) -> Bool {
        let str = str as NSString
        for i in 0..<str.length {
            let word = str.character(at: i)
            if word >= 0x4e00 && word <= 0x9fff {
                return true
            }
        }
        return false
    }

    private func saveContact(_ contact: CNMutableContact) {
        let saveRequest = CNSaveRequest()
        saveRequest.update(contact)
        do {
            try self.contactStore.execute(saveRequest)
        } catch {
            DLog("saving Contact failed ! - \(error)")
        }
    }
    
    private func contactList() -> [CNContact]? {
        var ret = [CNContact]()
        DLog("start")
        requestContactStoreAuthorization()
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else {
            return ret
        }
        
        // CNContactPhoneNumbersKey
        let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneticFamilyNameKey, CNContactPhoneticGivenNameKey, CNContactPhoneNumbersKey]
        
        let fetch = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        do {
            try CNContactStore().enumerateContacts(with: fetch, usingBlock: { (contact, stop) in
                ret.append(contact)
            })
        } catch let error as NSError {
            DLog(error)
        }
        DLog("end(\(ret.count))")
        return ret
    }
}
