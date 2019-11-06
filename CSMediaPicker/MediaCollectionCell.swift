//
//  MediaCollectionCell.swift
//  CSMediaPickingFlow
//
//  Created by CloverField on 23/10/2019.
//  Copyright © 2019 CloverField. All rights reserved.
//

import UIKit
import Photos
import Foundation

class MediaCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaPreviewImage: UIImageView!
    @IBOutlet weak var videoDurationLabel: UILabel!
    @IBOutlet weak var mediaTypeImage: UIImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var selectedOverlay: UIView!
    
    var cellHeight: CGFloat?{
        didSet{
            if self.cellHeight != nil{
                setLayout()
            }
        }
    }
    
    var asset:PHAsset?{
        didSet{
            if self.asset != nil{
                setCell()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool{
        didSet{
            self.selectedOverlay.isHidden = !self.isSelected
        }
    }
    
    func setLayout(){
        imageWidth.constant = cellHeight!
        imageHeight.constant = cellHeight!
    }
    
    func setCell(){
        
        if asset?.mediaType == PHAssetMediaType.video{
        
            let componentFormatter = DateComponentsFormatter()

            componentFormatter.allowedUnits = [.minute, .second]
            componentFormatter.zeroFormattingBehavior = .pad

            if let formattedString = componentFormatter.string(from: asset!.duration) {
                videoDurationLabel.text = formattedString
            }
            
            videoDurationLabel.isHidden = false
            mediaTypeImage.isHidden = false
        }
        else{
            videoDurationLabel.isHidden = true
            mediaTypeImage.isHidden = true
        }
        
        asset?.getImage(size: CGSize(width: mediaPreviewImage.frame.size.width, height: mediaPreviewImage.frame.size.height), completion: { (image) -> Void in
            
            self.mediaPreviewImage.image = image
            
        })
    }
    
}

