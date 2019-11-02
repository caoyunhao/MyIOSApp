//
//  NotificationHelper.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/7/21.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationHelper {
    
    static let `default` = NotificationHelper()
    
    let center = UNUserNotificationCenter.current();
    
    func register() {
        let pushtypes : UNAuthorizationOptions = [
            .badge,
            .alert,
            .sound,
        ]
        
        //2.注册推送
        //本地通知只有app位于后台才会显示
        center.requestAuthorization(options: pushtypes) { (success, error) in
            if success {
                DLog("注册成功")
            }
        }
//        var date = DateComponents()
//        date.hour = 10
//        date.minute = 36
//        addCalendar(content: "content", date: date)
    }
    
    func addCalendar(content: String, date: DateComponents) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "title"
        notificationContent.body = content
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        center.add(UNNotificationRequest(identifier: "123", content: notificationContent
            , trigger: trigger), withCompletionHandler: nil)
    }
    
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
                DLog("Time Interval (\(timeInterval) Notification scheduled: \(requestIdentifier)")
            }
        }
    }
}
