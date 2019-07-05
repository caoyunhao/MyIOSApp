//
//  LocalizedStrings.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/5.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import Foundation

class LocalizedStrings {
    static var NOTICE: String  {
        return "NOTICE".localized
    }
    
    static var UTILITIES: String  {
        return "UTILITIES".localized
    }
    
    static var IMAGE: String  {
        return "IMAGE".localized
    }
    
    static var VIDEO: String  {
        return "VIDEO".localized
    }
    
    static var CONTACT: String  {
        return "CONTACT".localized
    }
    
    static var LOCAL_STORAGE: String  {
        return "LOCAL_STORAGE".localized
    }
    
    static var ABOUT: String  {
        return "ABOUT".localized
    }
    
    static var PASTEBOARD_HISTORY: String  {
        return "PASTEBOARD_HISTORY".localized
    }
    
    static var SCAN: String  {
        return "SCAN".localized
    }
    
    static var TODO_LIST: String  {
        return "TODO_LIST".localized
    }
    
    static var CANCEL: String  {
        return "CANCEL".localized
    }
    
    static var OK: String  {
        return "OK".localized
    }
    
    static var JUMP: String  {
        return "JUMP".localized
    }
}

enum Language {
    case english
    case chinese
}

class LocalizationHelper {
    private static let languageKey = "language_key"
    static let shared = LocalizationHelper()
    
    
    private var bundle: Bundle? = nil
    private var currentLanguage: Language!
    
    init() {
        clean()
        currentLanguage = getLanguage()
//        set(.chinese)
    }
    
    fileprivate func value(forKey key: String) -> String {
        if let bundle = self.bundle {
            DLog(message: "success for key \(key)")
            return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
        } else {
            DLog(message: "error for key \(key)")
            return NSLocalizedString(key, comment: "")
        }
    }
    
    func set(_ language: Language) {
        if language == currentLanguage {
            DLog(message: "same language")
            return
        }
        currentLanguage = language
        switch language {
        case .chinese:
            UserDefaults.standard.set("cn", forKey: LocalizationHelper.languageKey)
            loadBundle(languageName: "zh-Hans")
        case .english:
            UserDefaults.standard.set("en", forKey: LocalizationHelper.languageKey)
            loadBundle(languageName: "en")
        }
    }
    
    private func getLanguage() -> Language {
        var languageName = ""
        if let language = UserDefaults.standard.value(forKey: LocalizationHelper.languageKey) as? String {
            languageName = language == "cn" ? "zh-Hans" : "en"
        } else {
            languageName = getSystemLanguage()
//            UserDefaults.standard.set(languageName, forKey: LocalizationHelper.languageKey)
        }
        loadBundle(languageName: languageName)
        return languageName == "en" ? .english : .chinese
    }
    
    private func loadBundle(languageName: String) {
        if let path = Bundle.main.path(forResource:languageName , ofType: "lproj") {
            DLog(message: "success. languageName=\(languageName)")
            bundle = Bundle(path: path)
        } else {
            DLog(message: "error!!! languageName=\(languageName)")
        }
    }
    
    private func getSystemLanguage() -> String {
        let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
        switch String(describing: preferredLang) {
        case "en-US", "en-CN":
            return "en"
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
            return "zh-Hans"
        default:
            return "en"
        }
    }
    
    func clean() {
        UserDefaults.standard.removeObject(forKey: LocalizationHelper.languageKey)
    }
}

fileprivate extension String {
    var localized: String {
        return LocalizationHelper.shared.value(forKey: self)
    }
}

