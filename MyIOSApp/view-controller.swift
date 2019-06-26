//
//  view-controller.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/12/30.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

func popperNav(vc: UIViewController, nextVC: UIViewController) {
    let navVC = UINavigationController(rootViewController: vc);
    vc.present(navVC, animated: true)
}
