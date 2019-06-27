//
//  ACollectionViewCell.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/8/11.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class ImagesViewCell: UICollectionViewCell {
    
    // ImagesViewCell
    var data: PhotoMultiSelectionItem! {
        didSet {
            let item = data!
            
            if item.image.type == .live {
                badgeImageView.image = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
            } else {
                badgeImageView.image = nil
            }

            //获取缩略图
            //        self.imageManager.requestImage(for: asset,targetSize: assetGridThumbnailSize,contentMode: .aspectFill,options: nil) {
            //            (image, nfo) in
            //            cell.imageView.image = image
            //
            //        }
            
            imageView.image = item.image.first
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var selectionSwitch: UISwitch!
    @IBOutlet weak var selectionViewHolder: UIView!
    @IBOutlet weak var selectionFlagImage: UIImageView!
    
    static let image: UIImage = UIImage(named: "QuickActions_Confirmation")!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        selectionFlagView
        selectionFlagImage.layer.cornerRadius = selectionFlagImage.frame.width * 0.5
    }
    
    public func select() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        // selectionSwitch.setOn(true, animated: true);
        selectionViewHolder.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.38)
        selectionFlagImage.image = ImagesViewCell.image
        selectionFlagImage.backgroundColor = .yellow
    }
    
    public func deselect() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
//        selectionSwitch.setOn(false, animated: true);
        selectionViewHolder.backgroundColor = .clear
        
        selectionFlagImage.image = nil
        selectionFlagImage.backgroundColor = .clear
    }

}
