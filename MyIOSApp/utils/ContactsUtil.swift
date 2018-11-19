//
//  contacts.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/26.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation
import Contacts

class ContactsUtil: NSObject {
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
                DLog(message: "已授权")
            }
        })
    }
    
    lazy var locationInfo:[String: String] = {
        return Serialization.json(fileName: "mobile_location", type: "json") as! [String: String]
    }()
    
    func checkContactStoreAuth(){
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined:
            DLog(message: "未授权")
            requestContactStoreAuthorization()
        case .authorized:
            DLog(message: "已授权")
        case .denied, .restricted:
            DLog(message: "无权限")
            //可以选择弹窗到系统设置中去开启
        }
    }
    
    
    func enumerateContacts(_ handleOneContrct: @escaping (CNMutableContact) -> ()) {
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else {
            return
        }
        // CNContactPhoneNumbersKey
        let keys = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneticFamilyNameKey, CNContactPhoneticGivenNameKey, CNContactPhoneNumbersKey]
        
        let fetch = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
            try self.contactStore.enumerateContacts(with: fetch, usingBlock: { (contact, stop) in
                if !contact.familyName.isEmpty || !contact.givenName.isEmpty {
                    
                    let mutableContact: CNMutableContact = contact.mutableCopy() as! CNMutableContact
                    handleOneContrct(mutableContact)
 
                    self.saveContact(mutableContact)
                }
            })
        } catch let error as NSError {
            DLog(message: error)
        }
    }

    private func phonetic_one(_ mutableContact: CNMutableContact) {
        var phoneticFamilyResult = ""
        var phoneticGivenResult  = ""
        // var phoneticFamilyBrief  = ""
        // var phoneticGivenBrief   = ""
        
        
        if let family = mutableContact.value(forKey: CNContactFamilyNameKey) as? String {
            if self.antiPhonetic(family) {
                let cffamily = NSMutableString(string: family) as CFMutableString
                DLog(message: "\(cffamily)")
                CFStringTransform(cffamily, nil, kCFStringTransformMandarinLatin, false)
                DLog(message: "\(cffamily)")
                phoneticFamilyResult = ((cffamily as NSString).capitalized) as String
            }
        }
        
        if let given = mutableContact.value(forKey: CNContactGivenNameKey) as? String {
            if self.antiPhonetic(given) {
                let cfGiven = NSMutableString(string: given) as CFMutableString
                DLog(message: "\(cfGiven)")
                CFStringTransform(cfGiven, nil, kCFStringTransformMandarinLatin, false)
                DLog(message: "\(cfGiven)")
                phoneticGivenResult = ((cfGiven as NSString).capitalized) as String
            }
        }
        
        mutableContact.setValue(phoneticFamilyResult, forKey: CNContactPhoneticFamilyNameKey)
        mutableContact.setValue(phoneticGivenResult, forKey: CNContactPhoneticGivenNameKey)
    }

    private func callerloc_one(_ mutableContact: CNMutableContact) {
        var newElements: [CNLabeledValue<CNPhoneNumber>] = []
        for labeledValue in mutableContact.phoneNumbers {
            let originPhoneNumber = (labeledValue.value as CNPhoneNumber).stringValue
            let phoneNumber = originPhoneNumber
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: "\u{00A0}", with: "")
            
            if let item = self.locationInfo[phoneNumber.prefix(7).description] {
                let province_city = item.split(separator: "-")
                let province = province_city[0].description
                let city = province_city[1].description
                DLog(message:  (province, city))
                newElements.append(labeledValue.settingLabel("\(province) - \(city)"))
            } else {
                newElements.append(labeledValue)
            }
        }
        mutableContact.setValue(newElements, forKey: CNContactPhoneNumbersKey)
    }

    func phonetic(){
        self.requestContactStoreAuthorization()
        enumerateContacts(phonetic_one)
    }

    func callerloc(){
        self.requestContactStoreAuthorization()
        enumerateContacts(callerloc_one)
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
            DLog(message: "saving Contact failed ! - \(error)")
        }
    }
}
