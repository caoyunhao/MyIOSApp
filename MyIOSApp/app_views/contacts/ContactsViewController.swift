//
//  ContactsViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/6/11.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
    
    @objc
    func handleRefresh(sender: NSNotification) {
        refreshControl?.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        
        let searchController: UISearchController = UISearchController(searchResultsController: UIViewController())
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
