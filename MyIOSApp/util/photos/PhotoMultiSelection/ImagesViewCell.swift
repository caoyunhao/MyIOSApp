//
//  ACollectionViewCell.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/11.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit

class ImagesViewCell: UICollectionViewCell {
    
    // ImagesViewCell
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var selectionSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    public func select() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        selectionSwitch.setOn(true, animated: true);
    }
    
    public func deselect() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        selectionSwitch.setOn(false, animated: true);
    }

}
