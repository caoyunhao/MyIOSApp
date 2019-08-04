//
//  FieldTableView.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/19.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit



class FieldTableView: UITableView {
    
    struct Field {
        var name: String
        var placeholder: NSAttributedString?
        
        init(name: String, placeholder: NSAttributedString? = nil) {
            self.name = name
            self.placeholder = placeholder
        }
    }
    
    private let cellIndentifier = "cellIndentifier"
    
    var fields = [Field]()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
    }
    */
 
    
    override func awakeFromNib() {
        DLog("awakeFromNib")
    }
    
    func viewDidLoad() {
        register(UINib(nibName: "TextTableCellView", bundle: Bundle.main), forCellReuseIdentifier: cellIndentifier)
        dataSource = self
        alwaysBounceVertical = false
        alwaysBounceHorizontal = false
    }
    
    override func reloadData() {
        super.reloadData();
        frame.size.height = expectedHeight
    }
    
    var expectedHeight: CGFloat {
        var a: CGFloat = 0;
        for i in 0..<fields.count {
            DLog("i=\(i)")
            if let cell = cellForRow(at: IndexPath(row: i, section: 0)) {
                a += cell.frame.height
            }
        }
        DLog("expectedHeight: \(a)")
        return a;
    }
}

extension FieldTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        DLog("cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier) as! TextTableCellView
        cell.textField.attributedPlaceholder = fields[indexPath.row].placeholder
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
