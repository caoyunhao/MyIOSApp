//
//  phasset+.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/6/28.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import Photos

extension PHAsset {
    var cyhDescription: String {
        return "PHAsset(playbackStyle=\(playbackStyle)), \(mediaType), \(mediaSubtypes), W*H=\(pixelWidth)x\(pixelHeight), \(String(describing: creationDate)), \(String(describing: modificationDate)), \(duration), \(isHidden), \(isFavorite), location=\(String(describing: location)), \(String(describing: burstIdentifier)), \(burstSelectionTypes), \(representsBurst), \(sourceType)"
    }
    
    var cyhDescriptionFormatted: String {
        
        return """
        PHAsset.descriptionFormatted:
            playbackStyle       =   \(playbackStyle.cyhDescription),
            mediaType           =   \(mediaType.cyhDescription),
            mediaSubtypes       =   \(mediaSubtypes.rawValue),
            width*height        =   \(pixelWidth)x\(pixelHeight),
            creationDate        =   \(creationDate?.description ?? "nil"),
            modificationDate    =   \(modificationDate?.description ?? "nil"),
            duration            =   \(duration),
            isHidden            =   \(isHidden),
            isFavorite          =   \(isFavorite),
            location
                coordinate
                    latitude            = \(location?.coordinate.latitude.description ?? "nil")
                    longitude           = \(location?.coordinate.longitude.description ?? "nil")
                altitude            = \(location?.altitude.description ?? "nil")
                speed               = \(location?.speed.description ?? "nil")
                horizontalAccuracy  = \(location?.horizontalAccuracy.description ?? "nil")
                verticalAccuracy    = \(location?.verticalAccuracy.description ?? "nil")
                timestamp           = \(location?.timestamp.description ?? "nil")
                floor.level         = \(location?.floor?.level.description ?? "nil"),
            burstIdentifier     =   \(String(describing: burstIdentifier)),
            burstSelectionTypes =   \(burstSelectionTypes.rawValue),
            representsBurst     =   \(representsBurst),
            sourceType          =   \(sourceType.cyhDescription)
        """
    }
}


extension PHAssetSourceType {
    var cyhDescription: String {
        switch rawValue {
        case 0:
            return "typeUserLibrary"
        case 1:
            return "typeCloudShared"
        case 2:
            return "typeiTunesSynced"
        default:
            return "nil"
        }
    }
}

extension PHAssetBurstSelectionType {
    var cyhDescription: String {
        switch self {
        case .autoPick :
            return "autoPick"
        case .userPick:
            return "userPick"
        default:
            return "nil"
        }
    }
}

extension PHAssetMediaSubtype {
    var cyhDescription: String {
        switch self {
        case .photoPanorama:
            return "photoPanorama"
        case .photoHDR:
            return "photoHDR"
        case .photoScreenshot:
            return "photoScreenshot"
        case .photoLive:
            return "photoLive"
        case .photoDepthEffect:
            return "photoDepthEffect"
        case .videoStreamed:
            return "videoStreamed"
        case .videoHighFrameRate:
            return "videoHighFrameRate"
        case .videoTimelapse:
            return "videoTimelapse"
        default:
            return "nil"
        }
    }
}

extension PHAssetMediaType {
    var cyhDescription: String {
        switch self {
        case .unknown:
            return "unknown"
        case .image:
            return "image"
        case .video:
            return "video"
        case .audio:
            return "audio"
        default:
            return "nil"
        }
    }
}

extension PHAsset.PlaybackStyle {
    var cyhDescription: String {
        switch self {
        case .unsupported:
            return "unsupported"
        case .image:
            return "image"
        case .imageAnimated:
            return "imageAnimated"
        case .livePhoto:
            return "livePhoto"
        case .video:
            return "video"
        case .videoLooping:
            return "videoLooping"
        default:
            return "nil"
        }
    }
}

extension CLLocation {
    var cyhDescriptionFormatted: String {
        return """
        CLLocation
                coordinate          = \(coordinate)
                altitude            = \(altitude)
                speed               = \(speed)
                horizontalAccuracy  = \(horizontalAccuracy)
                verticalAccuracy    = \(verticalAccuracy)
                timestamp           = \(timestamp)
                floor.level         = \(floor?.level)
        """
    }
}
