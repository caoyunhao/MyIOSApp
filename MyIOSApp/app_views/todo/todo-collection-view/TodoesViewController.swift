//
//  TodoesViewController.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/6/26.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TodoCollectionViewCell"
private let columnsNum: Int = 1
private let cornerRadius: CGFloat = 10

class TodoesViewController: UIViewController {

    @IBOutlet weak var collectionView: CYHCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Todoes"
        DLog(view.frame)
        DLog(view.safeAreaInsets)
        DLog("UIScreen.main.bounds=\(UIScreen.main.bounds)")
        DLog("view.frame=\(view.frame)")
        
        
//        let collectionView = self.collectionView as! CYHCollectionView
        
//        let collectionView = CYHCollectionView(frame: safeAreaFrame(view: view), collectionViewLayout: UICollectionViewFlowLayout())
//        let collectionView = CYHCollectionView(frame: view.safeAreaFrame, collectionViewLayout: UICollectionViewFlowLayout())
        DLog("collectionView.frame=\(collectionView.frame)")
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.searchController = UISearchController(searchResultsController: UIViewController())

//        view.frame.size.width = UIScreen.main.bounds.width
//        collectionView.frame.size.width = UIScreen.main.bounds.width
        
        collectionView.columnsNum = columnsNum
        collectionView.cellSpace = cornerRadius
        collectionView.widthTotal = UIScreen.main.bounds.width
        collectionView.setup()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .gray
        collectionView.alwaysBounceVertical = true
        
//        self.view.addSubview(collectionView)
        
//        ConstraintUtil.alignCompletely(self.view, child: collectionView)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        collectionView.register(UINib(nibName: reuseIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: reuseIdentifier)
        
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

extension TodoesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        let numberOfItems = collectionView.numberOfItems(inSection: section)
//        return UIEdgeInsets.zero
//    }
    
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
        cell.layer.cornerRadius = cornerRadius
        
//        DLog("cell.size=\(cell.frame.size)")
        
        // Configure the cell
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        DLog("scrollViewDidScroll")
    }
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
//        DLog("scrollViewDidChangeAdjustedContentInset")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        DLog("scrollViewDidEndDragging")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        DLog("scrollViewWillBeginDecelerating")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        DLog(velocity)
    }
}


