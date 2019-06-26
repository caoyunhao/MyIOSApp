//
//  MainTabBarController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/6/10.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todoListVC = UINavigationController(rootViewController: CommonUtils.loadNib(ofViewControllerType: TodoListViewController.self))
        todoListVC.tabBarItem = UITabBarItem(title: "Todo", image: UIImage(named: "task_list"), tag: 0)
        
        let tasksVC = UINavigationController(rootViewController: CommonUtils.loadNib(ofViewControllerType: MessagesViewController.self))
        let image = UIImage(named: "task_list")
        tasksVC.tabBarItem = UITabBarItem(title: "History", image: image, selectedImage: nil)
        
        let moreVC = UINavigationController(rootViewController: CommonUtils.loadNib(ofViewControllerType: ToolsViewController.self))
        moreVC.navigationItem.largeTitleDisplayMode = .always
        moreVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 0)
        
        self.viewControllers = [
            todoListVC,
            tasksVC,
            moreVC
        ]

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
