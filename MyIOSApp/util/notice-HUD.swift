//
//  notice-HUD.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/4.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class NoticeHUDManager: NSObject {
    
    static let shared = NoticeHUDManager()

}

class NoticeHUD: NSObject {
    private static var windows: [UIWindow] = []
    private static let rv: UIView = UIApplication.shared.keyWindow!.subviews.first!
    
    private static var degree: Double {
        get {
            return [0, 0, 180, 270, 90][UIApplication.shared.statusBarOrientation.hashValue] as Double
        }
    }
    
    class Options {
        var indicator = false
        var textAlingment: NSTextAlignment = .center
        var autoCleanTimeInterval: TimeInterval = -1
        var fontSize: CGFloat = 13.0
        var cancelText: String?
    }
    
    private var text: String
    private let options: NoticeHUD.Options
    private let label: UILabel
    private let window: UIWindow
    private let mainView: UIView
    private var initialized = false
    private var shown = false
    private var closed = false
    
    init(text: String, options: NoticeHUD.Options) {
        self.text = text
        self.options = options
        
        self.label = UILabel()
        
        label.text = self.text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: options.fontSize)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        
        self.window = UIWindow()
        self.window.backgroundColor = UIColor.clear
        
        self.mainView = UIView()
        self.mainView.layer.cornerRadius = 12
        self.mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
    }
    
    func initialize() {
        guard !self.initialized else {
            return
        }
        self.initialized = true
        
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        mainView.addSubview(label)
        window.addSubview(mainView)
        NoticeHUD.windows.append(window)
    }
    
    func show() {
        DLog(message: "show")
        layout()
        initialize()
        
        if options.autoCleanTimeInterval > 0 {
            self.perform(#selector(clean(_:)), with: window, afterDelay: options.autoCleanTimeInterval)
        }
    }
    
    func motify(text: String) {
        label.text = text
        layout()
    }
    
    private func layout() {
        let fittedSize = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 82, height: CGFloat.greatestFiniteMagnitude))
        label.bounds = CGRect(x: 0, y: 0, width: fittedSize.width, height: fittedSize.height)
        let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 50 , height: label.frame.height + 30)
        window.frame = superFrame
        mainView.frame = superFrame
        label.center = mainView.center
        window.center = NoticeHUD.rv.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = NoticeHUD.getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(NoticeHUD.degree * Double.pi / 180))
        }
    }
    
    @objc
    func clean(_ sender: AnyObject) {
        if !closed {
            closed = true
            DLog(message: "close")
            UIView.animate(withDuration: 0.2, animations: {
                if self.window.tag == 1001 {
                    self.window.frame = CGRect(x: 0, y: -self.window.frame.height, width: self.window.frame.width, height: self.window.frame.height)
                }
                self.window.alpha = 0
            }, completion: { b in
                NoticeHUD.windows.removeAll(where: { (window) -> Bool in
                    return self.window ==  window
                })
            })
        }
    }
    
    private static func getRealCenter() -> CGPoint {
        if UIApplication.shared.statusBarOrientation.rawValue >= 3 {
            return CGPoint(x: rv.center.y, y: rv.center.x)
        } else {
            return rv.center
        }
    }
}
