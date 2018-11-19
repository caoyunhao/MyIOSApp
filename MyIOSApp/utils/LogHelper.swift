//
//  LogHelper.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/7/3.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

func DLog<T> (message : T, method : String = #function, line : Int = #line)->(){
    #if DEBUG
    print("[DEBUG] >>> \(method) -- \(line): \(message)")
    #endif
}
