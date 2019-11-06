//
//  PHAssetCollectionExtension.swift
//  CSMediaPickingFlow
//
//  Created by CloverField on 22/10/2019.
//  Copyright © 2019 CloverField. All rights reserved.
//

import Photos
import UIKit

extension PHAssetCollection{
    
    var photosCount: Int {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        let result = PHAsset.fetchAssets(in: self, options: fetchOptions)
        return result.count
    }
    
    var videosCount: Int {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        let result = PHAsset.fetchAssets(in: self, options: fetchOptions)
        return result.count
    }
    
    var mediaCount: Int {
        return self.photosCount + self.videosCount
    }
    
    func latestMediaPreviewImage(size:CGSize?, completion:@escaping(_ result: UIImage) -> Void){
        
        let trueSize: CGSize = size ?? PHImageManagerMaximumSize
        
        let defaultImage = UIImage()
        
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        let fetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: self, options: fetchOptions)
        if fetchResult.count > 0 {
            
            let initialRequestOptions = PHImageRequestOptions()
            initialRequestOptions.isSynchronous = true
            initialRequestOptions.resizeMode = .fast
            initialRequestOptions.deliveryMode = .fastFormat
            
            let asset: PHAsset = fetchResult.firstObject!
            PHImageManager.default().requestImage(for: asset, targetSize: trueSize, contentMode: .aspectFit, options: initialRequestOptions) { (image, info) -> Void in
                if image != nil{
                    completion(image!)
                }
                else{
                    completion(defaultImage)
                }
            }
            
        }
        else{
            completion(defaultImage)
        }
    }
    
    func allAssetsFromCollection() -> PHFetchResult<PHAsset>{
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        let fetchResult: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: self, options: fetchOptions)
        
        return fetchResult;
    }
}

extension PHAsset{
    
    func getImage(size:CGSize?, completion:@escaping(_ result: UIImage) -> Void){
        
        let trueSize: CGSize = size ?? PHImageManagerMaximumSize
        let defaultImage = UIImage()
        
        let initialRequestOptions = PHImageRequestOptions()
        initialRequestOptions.isSynchronous = true
        initialRequestOptions.resizeMode = .fast
        initialRequestOptions.deliveryMode = .fastFormat
        
        PHImageManager.default().requestImage(for: self, targetSize: trueSize, contentMode: .aspectFill, options: initialRequestOptions) { (image, info) -> Void in
            if image != nil{
                completion(image!)
            }
            else{
                completion(defaultImage)
            }
        }
    }
    
    
}


