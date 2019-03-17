//
//  AlertHelper.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/7/3.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class AlertUtils: NSObject {
    static func simple(vc: UIViewController, message: String) {
        let alertController = UIAlertController(
            title: "Notice",
            message: message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                DLog(message: "\(message) -> OK")
            }
        )
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func biAction(
        vc: UIViewController,
        message: String,
        leftTitle: String,
        rightTitle: String,
        leftAction: (()->Void)?,
        rightAction: (()->Void)?
        ) {
        let alertController = UIAlertController(
            title: "Notice",
            message: message,
            preferredStyle: .alert)
        let leftAction = UIAlertAction(
            title: leftTitle,
            style: .cancel,
            handler: {
                (action: UIAlertAction!) -> Void in
                leftAction?()
            }
        )
        let rightAction = UIAlertAction(
            title: rightTitle,
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                rightAction?()
            }
        )
        alertController.addAction(leftAction)
        alertController.addAction(rightAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
