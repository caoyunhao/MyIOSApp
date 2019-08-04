//
//  AppUtil.swift
//  MyIOSApp
//
//  Created by Yunhao on 2018/11/12.
//  Copyright © 2018 Yunhao. All rights reserved.
//

import UIKit
import NetworkExtension
import MapKit

class SystemUtils {
    
//    static let PHOTOS_URL = "prefs:root=Photos"
    static let PHOTOS_URL = "photos-redirect://"

    static func openPhotos() {
        DLog("jump Photos")
        UIApplication.shared.open(URL(string: PHOTOS_URL)!, options: [:], completionHandler: nil)
    }
    
    static func openApplicationSetting() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
    }
    
    static func getWiFi() {
        let networkInterfaces = NEHotspotHelper.supportedNetworkInterfaces()
        DLog(networkInterfaces)

    }
    
    static func openMap(targetLat:Double, targetLon:Double) {
        DLog("openMap")
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(floatLiteral: targetLat), longitude: CLLocationDegrees(floatLiteral: targetLon))))
        MKMapItem.openMaps(with: [mapItem], launchOptions: nil)
    }
}
