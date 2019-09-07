//
//  UIPasteboard+.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/8/14.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

extension UIPasteboard {
    
    func clear() {
        string = ""
        image = UIImage()
        url = URL(fileURLWithPath: "/")
        color = UIColor.clear
        
        images = []
        urls = []
        colors = []
        strings = []
        
        items = []
    }
}
