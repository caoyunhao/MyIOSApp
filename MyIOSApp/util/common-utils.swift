//
//  CommonUtil.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/17.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class ClassUtils {
    static func simpleName(class clazz: AnyClass) -> String {
        return String(NSStringFromClass(clazz.self).split(separator: ".").last!)
    }
}

class CommonUtils {
    
    static func loadNib (ofViewControllerType type: UIViewController.Type) -> UIViewController {
        return type.init(nibName: ClassUtils.simpleName(class: type.self), bundle: Bundle.main)
    }
}
