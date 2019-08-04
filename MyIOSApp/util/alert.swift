//
//  AlertHelper.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/7/3.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class AlertUtils: NSObject {
    static func simple(vc: UIViewController, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(
            title: LocalizedStrings.NOTICE,
            message: message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: LocalizedStrings.I_GOT_IT,
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                DLog("\(message) -> OK")
                completion?()
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
            title: LocalizedStrings.NOTICE,
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
