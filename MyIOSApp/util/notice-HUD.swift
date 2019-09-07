//
//  notice-HUD.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/4.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class UINotice: NSObject {
    private static var windows: [UIWindow] = []
    private static let rv: UIView = UIApplication.shared.keyWindow!.subviews.first!
    
    private static var degree: Double {
        get {
            return [0, 0, 180, 270, 90][UIApplication.shared.statusBarOrientation.hashValue] as Double
        }
    }
    
    let processBarWidth: CGFloat = 60
    let processRadius: CGFloat = 20
    
    class Options {
        var indicator = false
        var textAlingment: NSTextAlignment = .center
        var autoLayout = true
        var autoCleanTimeInterval: TimeInterval = 0.5
        var fontSize: CGFloat = 13.0
        var cancelText: String?
        var hasProgress = false
    }
    
    private let options: UINotice.Options?
    private let label: UILabel
    
    private let window: UIWindow
    private let mainView: UIView
    private var initialized = false
    private var shown = false
    private var closed = false
    
    private var progressLayer: CAShapeLayer? = nil
    
    private var percentLabel: UILabel? = nil
    
    var text: String = "" {
        didSet {
            if self.options?.autoLayout ?? false && self.initialized {
                self.layout()
            }
        }
    }
    var progress: Double = 0 {
        didSet {
            if self.options?.autoLayout ?? false && self.initialized && self.options?.hasProgress ?? false {
                self.layout()
            }
        }
    }
    
    private var delay: TimeInterval?
    
    init(text: String, options: UINotice.Options? = nil) {
        self.text = text
        self.options = options
        
        self.label = UILabel()
        
        label.text = self.text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: options?.fontSize ?? 13.0)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        
        if options?.hasProgress ?? false {
            self.percentLabel = UILabel()
            percentLabel!.numberOfLines = 1
            percentLabel!.font = UIFont.systemFont(ofSize: options?.fontSize ?? 7.0)
            percentLabel!.textAlignment = NSTextAlignment.center
            percentLabel!.textColor = UIColor.white
            percentLabel!.adjustsFontSizeToFitWidth = true
            
            let progressLayer = CAShapeLayer()
            progressLayer.lineCap = "round"
            progressLayer.lineWidth = 5
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.strokeColor = UIColor.white.cgColor
            self.progressLayer = progressLayer
        }
        
        self.mainView = UIView()
        self.mainView.layer.cornerRadius = 12
        self.mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.618)
        
        self.window = UIWindow()
        self.window.backgroundColor = UIColor.clear
    }
    
    func initialize() {
        guard !self.initialized else {
            return
        }
        self.initialized = true
        
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        mainView.addSubview(label)
        if percentLabel != nil, progressLayer != nil {
            mainView.addSubview(percentLabel!)
            mainView.layer.addSublayer(progressLayer!)
        }
        
        window.addSubview(mainView)
        UINotice.windows.append(window)
    }
    
    func disappear(afterSeconds seconds: TimeInterval) -> UINotice {
        self.delay = seconds
        return self
    }
    
    func show() {
        initialize()
        layout()
        
        let delay = self.delay ?? options?.autoCleanTimeInterval ?? 1.0
        
        if delay > 0 {
            self.perform(#selector(clean(_:)), with: window, afterDelay: delay)
        }
    }
    
    func layout() {
        self.label.text = self.text
        let fittedSize = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width * 0.8, height: CGFloat.greatestFiniteMagnitude))
        label.bounds = CGRect(x: 0, y: 0, width: fittedSize.width, height: fittedSize.height)
        
        if options?.hasProgress ?? false {
            let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 20 , height: max(processBarWidth, label.frame.height + processBarWidth + 10))
            window.frame = superFrame
            mainView.frame = superFrame
            label.center = CGPoint(x: mainView.center.x, y: mainView.center.y + processBarWidth * 0.5)
        } else {
            let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 20 , height:  label.frame.height + 20)
            window.frame = superFrame
            mainView.frame = superFrame
            label.center = mainView.center
        }
        
        window.center = UINotice.rv.center
        
        if let pl = self.progressLayer {
            let point = CGPoint(x: mainView.center.x, y: processBarWidth / 2)
            let radius = processRadius
            let start = -Double.pi / 2
            let end = start + Double.pi * 2 * progress;
            
            let path = UIBezierPath(arcCenter: point, radius: radius, startAngle: CGFloat(start), endAngle: CGFloat(end), clockwise: true)
            pl.path = path.cgPath
        }
        
        if let percentLabel = self.percentLabel {
            percentLabel.frame = CGRect(x: mainView.center.x - processBarWidth / 2, y: processBarWidth * 0, width: processBarWidth, height: processBarWidth)
            percentLabel.text = "\(Int(progress * 100))%"
        }
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = UINotice.getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(UINotice.degree * Double.pi / 180))
        }
    }
    
    func hide() {
        if !closed {
            closed = true
            DLog("close")
            UIView.animate(withDuration: 0.2, animations: {
                if self.window.tag == 1001 {
                    self.window.frame = CGRect(x: 0, y: -self.window.frame.height, width: self.window.frame.width, height: self.window.frame.height)
                }
                self.window.alpha = 0
            }, completion: { b in
                UINotice.windows.removeAll(where: { (window) -> Bool in
                    return self.window ==  window
                })
            })
        }
    }
    
    func hide(afterDelay delay: TimeInterval) {
        self.perform(#selector(clean(_:)), with: self, afterDelay: delay)
    }
    
    @objc
    func clean(_ sender: AnyObject) {
        hide()
    }
    
    private static func getRealCenter() -> CGPoint {
        if UIApplication.shared.statusBarOrientation.rawValue >= 3 {
            return CGPoint(x: rv.center.y, y: rv.center.x)
        } else {
            return rv.center
        }
    }
}
