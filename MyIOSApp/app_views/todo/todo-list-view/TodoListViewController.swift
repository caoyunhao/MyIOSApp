//
//  TodoListViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/6/17.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "TodoListCell"

class SwipeConfig {
    var leftConfigs = [SwipeItemConfig]()
    var rightConfigs = [SwipeItemConfig]()
}

class SwipeItemConfig {
    fileprivate var backgroundColor: UIColor?
    fileprivate var title: String
    fileprivate var style: UIContextualAction.Style
    fileprivate var handle: ((IndexPath) -> Void)?
    
    init(title: String, style: UIContextualAction.Style, backgroundColor: UIColor? = nil, handle: ((IndexPath) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.backgroundColor = backgroundColor
        self.handle = handle
    }
}

class TodoListViewController: UITableViewController {
    var margin: CGFloat = 6
    var cornerRadius: CGFloat! = 6
    
    var config = SwipeConfig()
    
    fileprivate var swipeContext = SwipeContext()
    
    fileprivate class SwipeContext {
        enum Direction {
            case fromLeft
            case fromRight
        }
        fileprivate var isStart = true
        fileprivate var currentIndexPath: IndexPath?
        fileprivate var direction: Direction = .fromRight
    }
    
    private var tasks: [Task] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = LocalizedStrings.TODO_LIST
        self.tableView.alwaysBounceVertical = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.searchController = UISearchController(searchResultsController: UIViewController())
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.add))
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        config.leftConfigs.append(SwipeItemConfig(title: "Done", style: .normal))
        
        let deleteConfig = SwipeItemConfig(title: "Delete", style: .destructive)
        deleteConfig.handle = { indexPath in
            let task = self.tasks[indexPath.row]
            if TodoDB.default.delete(taskId: task.id) {
                DLog("delete success")
            } else {
                DLog("delete fail")
            }
        }

        config.rightConfigs.append(deleteConfig)
        
        DLog("frame=\(view.frame)")
        DLog("tableView.frame=\(tableView.frame)")
        
        tasks = TodoDB.default.queryTasks()
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        swipeProcess()
    }
    
    func swipeProcess() {
        if !swipeContext.isStart {
            return
        }
        
        if let curIndexPath = swipeContext.currentIndexPath {
            if curIndexPath.row < 0 { return }
            
            let cell = tableView.cellForRow(at: curIndexPath)!
            let sup = UIDevice.current.systemVersion >= "11" ? tableView : cell
            let swipeStr = UIDevice.current.systemVersion >= "11" ? "UISwipeActionPullView" : "UITableViewCellDeleteConfirmationView"
            let actionStr = UIDevice.current.systemVersion >= "11" ? "UISwipeActionStandardButton" : "_UITableViewCellActionButton"
            
            let buttonLabel = "UIButtonLabel"
            
            (sup!.subviews.filter { (view) -> Bool in
                return String(describing: view).range(of: swipeStr) != nil
            }).forEach { (swipeView) in
                DLog("subView frame: \(swipeView.frame)")
                swipeView.layer.masksToBounds = true
                
                (swipeView.subviews.filter { (view) in
                    return String(describing: view).range(of: actionStr) != nil
                }).forEach({ (button) in
                    button.backgroundColor = .clear
//                    button.tintColor = .red
                    
                    for subView in button.subviews {
                        subView.backgroundColor = .clear
                        if String(describing: subView).range(of: buttonLabel) != nil {
                            subView.tintColor = .red
                            
                        }
                        
                    }
                    
                    DLog("button frame: \(button.frame)")
                    
                    button.layer.masksToBounds = true;
                    
                    DLog("button final frame: \(button.frame)")
                    
                    swipeContext.isStart = false
                })
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TodoListCell

        // Configure the cell...
        let task = tasks[indexPath.row]
        
        cell.data = task
        cell.titleTextField.text = task.title
        cell.detailTextField.text = task.detail
        
        cell.margin = margin
        cell.cornerRadius = cornerRadius
        
//        cell.detailTextField.sizeToFit()
        
//        DLog(cell.detailTextField.preferredMaxLayoutWidth)
        
//        cell.detailTextField.sizeToFit()

        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        swipeContext.currentIndexPath = indexPath
        swipeContext.isStart = true
//        view.setNeedsLayout()
    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        DLog("editActionsForRowAt \(indexPath.row)")
//
//        let delete = UITableViewRowAction(style: .destructive, title: "删11111111111111除") {
//            action, index in
//            //将对应条目的数据删除
//            DLog("delete \(indexPath.row)")
//        }
//
//        return [delete]
//    }
    
    // 从左侧划出
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        var actions = [UIContextualAction]()
        
        for configItem in config.leftConfigs {
            let action = UIContextualAction(style: configItem.style, title: configItem.title) { (action, view, handler) in
                DLog("left \(indexPath.row)")
                configItem.handle?(indexPath)
            }
//            action.backgroundColor = configItem.backgroundColor
            action.image = UIImage(named: "QuickActions_Confirmation")
            action.backgroundColor = .clear
            actions.append(action)
        }
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    // 从右侧划出
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions = [UIContextualAction]()
        
        for configItem in config.rightConfigs {
            let action = UIContextualAction(style: configItem.style, title: configItem.title) { (action, view, handler) in
                handler(true)
                configItem.handle?(indexPath)
            }
            action.image = UIImage(named: "QuickActions_Confirmation")
//            action.backgroundColor = .clear
            actions.append(action)
        }
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    @objc
    func handleRefresh(sender: NSNotification) {
        self.refreshingData()
        refreshControl?.endRefreshing()
    }
    
    func refreshingData() {
        tasks = TodoDB.default.queryTasks()
//        let t = CATransition()
//        t.type = kCATransitionReveal
//        t.subtype = kCATransitionFromRight
//        t.duration = 0.4
//        tableView.layer.add(t, forKey: nil)
//        tableView.endUpdates()
        let lastScrollOffset = tableView.contentOffset
//        tableView.isHidden = true
        tableView.reloadData()
//        tableView.isHidden = false
        tableView.layoutIfNeeded()
        tableView.setContentOffset(lastScrollOffset, animated: false)
    }
    
    @objc
    func add(_ sender: AnyObject) {
        let addVC = CommonUtils.loadNib(ofViewControllerType: EditTodoViewController4.self)
        let navVC = UINavigationController(rootViewController: addVC)
        
        self.present(navVC, animated: true)
    }
}
