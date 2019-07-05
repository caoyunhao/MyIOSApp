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
    var margin: CGFloat = 10.0
    var cornerRadius: CGFloat! = 20
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = LocalizedStrings.TODO_LIST
        self.tableView.alwaysBounceVertical = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.searchController = UISearchController(searchResultsController: UIViewController())

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.register(UINib(nibName: cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        DLog(message: "frame=\(view.frame)")
        DLog(message: "tableView.frame=\(tableView.frame)")
        
        config.leftConfigs.append(SwipeItemConfig(title: "Flag", style: .normal))
        config.rightConfigs.append(SwipeItemConfig(title: "Delete", style: .destructive))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DLog(message: "viewWillLayoutSubviews")
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
            
            if let swipeView = (sup!.subviews.first { (view) -> Bool in
                return String(describing: view).range(of: swipeStr) != nil
            }) {
                DLog(message: "subView frame: \(swipeView.frame)")
                
                switch swipeContext.direction {
                case .fromLeft:
                    swipeView.frame.origin.x -= margin
                case .fromRight:
                    swipeView.frame.origin.x += margin
                }
                DLog(message: "subView final frame: \(swipeView.frame)")
//                swipeView.backgroundColor = .clear
                swipeView.layer.masksToBounds = true
                
                for sub in swipeView.subviews {
                    if String(describing: sub).range(of: actionStr) != nil {
                        if let button = sub as? UIButton {
                            DLog(message: "button frame: \(button.frame)")
                            swipeContext.direction = button.frame.origin.x >= 0 ? .fromRight: .fromLeft
                            
                            switch swipeContext.direction {
                            case .fromLeft:
                                button.cornersRadius(byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
                            case .fromRight:
                                button.cornersRadius(byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
                            }
                            
                            button.layer.masksToBounds = true;
                            
                            DLog(message: "button final frame: \(button.frame)")
                        }
                    }
                }
                
                swipeContext.isStart = false
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TodoListCell

        // Configure the cell...
        
        cell.titleTextField.text = "DMP 相关"
        let text: String;
        if indexPath.row % 2 == 0 {
            
            text = "broker 发版旧节点下掉时的报错问题发版旧节点下掉时的报错问题。broker 凌晨切换数据报错排查"
//            cell.detailTextField.attributedText = NSAttributedString(string: "broker 发版旧节点下掉时的报错问题\nbroker 凌晨切换数据报错排查")
        } else {
            text = "prophet-dispatcher、luwin-api 升级 jackson。luwin 排除 rec-ups-query 依赖。Java ForkedTransactionCommand。prophet-dispatcher、luwin-api 升级 jackson。luwin 排除 rec-ups-query 依赖。Java ForkedTransactionCommand"
//            cell.detailTextField.attributedText = NSAttributedString(string: "")
        }
        cell.detailTextField.text = text
        cell.margin = margin
        cell.cornerRadius = cornerRadius
        
//        cell.detailTextField.sizeToFit()
        
        DLog(message: cell.detailTextField.preferredMaxLayoutWidth)
        
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
//        DLog(message: "editActionsForRowAt \(indexPath.row)")
//
//        let delete = UITableViewRowAction(style: .destructive, title: "删11111111111111除") {
//            action, index in
//            //将对应条目的数据删除
//            DLog(message: "delete \(indexPath.row)")
//        }
//
//        return [delete]
//    }
    
    // 从左侧划出
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        var actions = [UIContextualAction]()
        
        for configItem in config.leftConfigs {
            let action = UIContextualAction(style: configItem.style, title: configItem.title) { (action, view, handler) in
                DLog(message: "left \(indexPath.row)")
                configItem.handle?(indexPath)
            }
            action.backgroundColor = configItem.backgroundColor
            actions.append(action)
        }
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    // 从右侧划出
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions = [UIContextualAction]()
        
        for configItem in config.rightConfigs {
            let action = UIContextualAction(style: configItem.style, title: configItem.title) { (action, view, handler) in
                DLog(message: "right \(indexPath.row)")
                configItem.handle?(indexPath)
            }
            action.backgroundColor = configItem.backgroundColor
            actions.append(action)
        }
        return UISwipeActionsConfiguration(actions: actions)
    }
}
