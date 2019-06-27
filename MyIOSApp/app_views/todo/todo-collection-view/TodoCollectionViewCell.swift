//
//  TodoCollectionViewCell.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/6/26.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class TodoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var flagImage: UIImageView!;
    @IBOutlet weak var titleTextField: UILabel!;
    @IBOutlet weak var detailTextField: UILabel!;

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowColor = UIColor.gray.cgColor
        layer.masksToBounds = false
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .white
        // Initialization code
    }

}
