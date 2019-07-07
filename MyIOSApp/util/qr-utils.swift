//
//  qr-utils.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/7.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

func FindFirstQRCode(cyhImage: CYHImage) -> String? {
    
    guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow]) else {
        return nil
    }
    
    for image in cyhImage.images {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }

        let results = detector.features(in: ciImage)
        
        for result in results {
            if let message = (result as! CIQRCodeFeature).messageString {
                return message
            }
        }
    }

    return nil
}
