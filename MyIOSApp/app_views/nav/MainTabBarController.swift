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
        
        self.navigationItem.largeTitleDisplayMode = .always
        
        let todoesVC = UINavigationController(rootViewController: CommonUtils.loadNib(ofViewControllerType: TodoesViewController.self))
        todoesVC.navigationBar.prefersLargeTitles = true
        todoesVC.tabBarItem = UITabBarItem(title: "Todoes", image: UIImage(named: "task_list"), tag: 0)
        
        let todoListVC = UINavigationController(rootViewController: CommonUtils.loadNib(ofViewControllerType: TodoListViewController.self))
        todoListVC.navigationBar.prefersLargeTitles = true
        todoListVC.tabBarItem = UITabBarItem(title: "Todo", image: UIImage(named: "task_list"), tag: 0)
        
        let tasksVC = UINavigationController(rootViewController: CommonUtils.loadNib(ofViewControllerType: MessagesViewController.self))
        tasksVC.navigationBar.prefersLargeTitles = true
        tasksVC.tabBarItem = UITabBarItem(title: "History", image: UIImage(named: "task_list"), selectedImage: nil)
        
        let moreVC = UINavigationController(rootViewController: CommonUtils.loadNib(ofViewControllerType: ToolsViewController.self))
        moreVC.navigationBar.prefersLargeTitles = true
        moreVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 0)
        
        self.viewControllers = [
//            todoesVC,
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
