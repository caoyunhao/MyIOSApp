//
//  LogHelper.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/7/3.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

func DLog<T> (_ message : T, fileName : String = #file, method : String = #function, line : Int = #line)->(){
    #if DEBUG
    print("[DEBUG]\(NSString(string: fileName).lastPathComponent):\(method):\(line): \(message)")
    #endif
}

//func DLog<T> (_ message : T, fileName : String = #file, method : String = #function, line : Int = #line)->(){
//    #if DEBUG
//    DLog("[DEBUG]\(NSString(string: fileName).lastPathComponent):\(method):\(line): \(message)")
//    #endif
//}
