//
//  TodoCollectionViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/6/19.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TodoCollectionViewCell"

class TodoCollectionViewController: UIViewController {
    
    private var collectionView: CYHCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = CYHCollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.columnsNum = 2
        collectionView.cellSpace = 1
        collectionView.setup()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        ConstraintUtil.alignCompletely(self.view, child: collectionView)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UINib(nibName: reuseIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource



    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}

extension TodoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TodoCollectionViewCell
        
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
        
        // Configure the cell
        
        return cell
    }
}
