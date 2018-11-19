//
//  CommonUtil.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/17.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class CommonUtil {
    
    static func loadNib (ofViewControllerType type: UIViewController.Type) -> UIViewController {
        return type.init(nibName: stringFrom(clazz: type.self), bundle: Bundle.main)
    }
    
    static func stringFrom(clazz: AnyClass) -> String {
        return String(NSStringFromClass(clazz.self).split(separator: ".").last!)
    }
    
//    static func  getFromNib <V: ViewController> (clazz: AnyClass) -> V {
//        clazz.init(nibName: CommonUtil.getNameFrom(clazz: ResizingViewController.self), bundle: Bundle.main)
//    }
}
