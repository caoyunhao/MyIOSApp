//
//  device.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/8.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import AVFoundation

func GetCaptureDevice(withPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    let deviceDescoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: position)
    
    for device in deviceDescoverySession.devices {
        if device.position == position {
            return device
        }
    }
    return nil
}
