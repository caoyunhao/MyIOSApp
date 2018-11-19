//
//  NotificationHelper.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/7/21.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationHelper {
    
    public static func newInstance(title: String, body: String, timeInterval: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        //设置通知触发器
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: false)
        
        //设置请求标识符
        let requestIdentifier = "com.hangge.testNotification"
        
        //设置一个通知请求
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        //将通知请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval (\(timeInterval) Notification scheduled: \(requestIdentifier)")
            }
        }
    }
}
