//
//  ViewControllerHelper.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/11.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class ViewControllerHelper {
    public static func close(_ vc: ViewController, render: UIButton) {
        vc.dismiss(animated: true, completion: nil)
    }
}


