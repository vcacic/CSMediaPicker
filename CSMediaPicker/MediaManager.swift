//
//  MediaManager.swift
//  CSMediaPickingFlow
//
//  Created by CloverField on 22/10/2019.
//  Copyright © 2019 CloverField. All rights reserved.
//

import Foundation
import Photos

class MediaManager{
    
    static let shared = MediaManager()
    
    func getAllMediaFolders() -> [PHAssetCollection] {
        
        var smartAlbums: PHFetchResult<PHAssetCollection>!
        var userCollections: PHFetchResult<PHAssetCollection>!
        
        
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        userCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype:.albumRegular, options: nil)
        
        var allAlbums:[PHAssetCollection] = []
        
        smartAlbums.enumerateObjects {(assetCollection, index, stop) in
            if assetCollection.mediaCount > 0{
                allAlbums.append(assetCollection)
            }
                
        }
        userCollections.enumerateObjects {(secondAssetCollection, index, stop) in
                
                if secondAssetCollection.mediaCount > 0{
                    allAlbums.append(secondAssetCollection)
                }
        }
        
        allAlbums.sort(by: {$0.mediaCount > $1.mediaCount})
        
        return allAlbums
        
    }
}

