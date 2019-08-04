//
//  localization-helper.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/7.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import Foundation

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
    
    func value(forKey key: String) -> String {
        if let bundle = self.bundle {
//            DLog("success for key \(key)")
            return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
        } else {
            DLog("error for key \(key)")
            return NSLocalizedString(key, comment: "")
        }
    }
    
    func set(_ language: Language) {
        if language == currentLanguage {
            DLog("same language")
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
            DLog("success. languageName=\(languageName)")
            bundle = Bundle(path: path)
        } else {
            DLog("error!!! languageName=\(languageName)")
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
