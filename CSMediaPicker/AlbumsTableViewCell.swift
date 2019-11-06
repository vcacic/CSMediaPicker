//
//  AlbumsTableViewCell.swift
//  CSMediaPickingFlow
//
//  Created by CloverField on 22/10/2019.
//  Copyright © 2019 CloverField. All rights reserved.
//

import UIKit
import Photos

class AlbumsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumsLatestPreviewImage: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var assetCountLabel: UILabel!
    @IBOutlet weak var nameLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var countLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    var cellHeight:CGFloat?{
        didSet{
            if self.cellHeight != nil {
                setCellLayout()
            }
        }
    }
    
    var albumCollection: PHAssetCollection? {
        didSet{
            if self.albumCollection != nil{
                setCellData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellLayout (){
        
        albumsLatestPreviewImage.layer.cornerRadius = cellHeight!*imageHeight.multiplier/2
        albumsLatestPreviewImage.layer.masksToBounds = true
        albumsLatestPreviewImage.layer.borderColor = UIColor.systemBlue.cgColor
        albumsLatestPreviewImage.layer.borderWidth = 2
        nameLabelHeight.constant = cellHeight!*imageHeight.multiplier/2
        countLabelHeight.constant = cellHeight!*imageHeight.multiplier/2
    
    }
    
    func setCellData() {
        albumNameLabel.text = albumCollection?.localizedTitle
        let size: CGSize = CGSize(width: albumsLatestPreviewImage.frame.size.width, height: albumsLatestPreviewImage.frame.size.width)
        albumCollection?.latestMediaPreviewImage(size: size, completion: {(image) -> Void in
            self.albumsLatestPreviewImage.image = image
        })
        assetCountLabel.text = "\(String(describing: albumCollection!.mediaCount))"
    }
    
    func getLastAssetPicture(){
        
    }
    
    func getAlbumAssetCount(){
        
    }
    
}
