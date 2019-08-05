//
//  ProjectViewCell.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/8/5.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit

class ProjectViewCell: UITableViewCell {
    
    var project: Project! {
        didSet {
            textLabel?.text = project.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
