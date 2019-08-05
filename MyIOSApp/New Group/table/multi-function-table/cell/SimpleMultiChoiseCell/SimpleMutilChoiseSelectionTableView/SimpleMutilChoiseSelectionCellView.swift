//
//  SimpleMutilChoiseSelectionCellView.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/8/6.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class SimpleMutilChoiseSelectionCellView: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView2: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
