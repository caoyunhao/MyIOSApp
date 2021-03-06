//
//  authorizaion.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/7/21.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation

import UserNotifications
import Photos

class NotificationAuthorization {
    public static func requestNotificationAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                (accepted, error) in
                if !accepted {
                    DLog("用户不允许消息通知。")
                }
        }
    }
    
    //    func checkPermission() {
    //        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    //        switch photoAuthorizationStatus {
    //        case .authorized: DLog("Access is granted by user")
    //        case .notDetermined: PHPhotoLibrary.requestAuthorization({
    //            (newStatus) in DLog("status is \(newStatus)")
    //            if newStatus == PHAuthorizationStatus.authorized {
    //                /* do stuff here */
    //                DLog("success")
    //            }
    //        })
    //        case .restricted:
    //            DLog("User do not have access to photo album.")
    //        case .denied:
    //            DLog("User has denied the permission.")
    //        }
    //    }
}
