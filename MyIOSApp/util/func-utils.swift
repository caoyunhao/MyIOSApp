//
//  func-util.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/5.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

func findCurrentViewController()->UIViewController{
    
    var window = UIApplication.shared.keyWindow
    if window?.windowLevel != UIWindowLevelNormal{
        let windows = UIApplication.shared.windows
        for  tempwin in windows{
            if tempwin.windowLevel == UIWindowLevelNormal{
                window = tempwin
                break
            }
        }
    }
    let frontView = (window?.subviews)![0]
    let nextResponder = frontView.next
//    Getdevice.println("getCurrentVC    XX \(frontView.classForCoder)")// iOS8 9 window  ios7 UIView
//    Getdevice.println("getCurrentVC    XX \((window?.subviews)!.count)")
//    Getdevice.println("getCurrentVC    XX \(nextResponder?.classForCoder)")
    if nextResponder?.isKind(of: UIViewController.classForCoder()) == true{
        
        return nextResponder as! UIViewController
    }else if nextResponder?.isKind(of: UINavigationController.classForCoder()) == true{
        
        return (nextResponder as! UINavigationController).visibleViewController!
    }
    else {
        
        if (window?.rootViewController) is UINavigationController{
            return ((window?.rootViewController) as! UINavigationController).visibleViewController!//只有这个是显示的controller 是可以的必须有nav才行
        }
        
        return (window?.rootViewController)!
        
    }
    
}

func findCurrentViewControllerV2() -> UIViewController! {
    return findControllerWithClass(UIViewController.self)
}

func findCurrentViewNavigationController() -> UINavigationController! {
    return findControllerWithClass(UINavigationController.self)
}

private func findControllerWithClass<T>(_ clzz: AnyClass) -> T? {
//    var responder = self.next
//    while(responder != nil) {
//        if (responder!.isKind(of: clzz)) {
//            return responder as? T
//        }
//        responder = responder?.next
//    }
    
    return nil
}
