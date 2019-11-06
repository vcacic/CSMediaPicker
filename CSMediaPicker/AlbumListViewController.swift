//
//  AlbumListViewController.swift
//  CSMediaPickingFlow
//
//  Created by CloverField on 22/10/2019.
//  Copyright © 2019 CloverField. All rights reserved.
//

import UIKit
import Photos

public protocol AlbumListDelegate {
    
    func selectedAssets( _ assets:[PHAsset])
}

public class AlbumListViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, AlbumDetailsDelegate, PHPhotoLibraryChangeObserver {
    
    let cellIdentifier = "albumCell"
    let cellName = "AlbumsTableViewCell"
    let cellHeight: CGFloat = 60
    
    @IBOutlet weak var albumsTableView: UITableView!
    
    var albumListArray:[PHAssetCollection]?
    public var delegate: AlbumListDelegate? = nil
    var selectedAlbum:PHAssetCollection?
    var selectedResult:PHFetchResult<PHAsset>?
    var selectedAssets:[PHAsset] = []
    var detailsViewController:AlbumDetailsViewController?
    var selectedIndex:IndexPath?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        albumListArray = MediaManager.shared.getAllMediaFolders()
        let bundle = Bundle(for: AlbumsTableViewCell.self)
        let customCell = UINib(nibName: cellName, bundle: bundle)
        albumsTableView.register(customCell, forCellReuseIdentifier: cellIdentifier)
        PHPhotoLibrary.shared().register(self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Media Albums"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label,
                                                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        selectedIndex = nil
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // MARK:TableView
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albumListArray!.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let album:PHAssetCollection = (albumListArray?[indexPath.row])!
        let cell:AlbumsTableViewCell = albumsTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AlbumsTableViewCell
        cell.cellHeight = cellHeight
        cell.albumCollection = album
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath
        selectedAlbum = (albumListArray?[indexPath.row])!
        selectedResult = selectedAlbum!.allAssetsFromCollection()
        let bundle  = Bundle(for: AlbumListViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        detailsViewController = storyboard.instantiateViewController(withIdentifier: "albumdetail") as? AlbumDetailsViewController
        detailsViewController!.albumName = selectedAlbum!.localizedTitle
        detailsViewController!.albumResult = selectedResult
        detailsViewController!.selectedItems = self.selectedAssets
        detailsViewController!.delegate = self
        self.navigationController?.pushViewController(detailsViewController!, animated: true)
    }
    
    // MARK:AlbumDetailsDelegate
    
    func assetFromAlbumSelected(_ albumName: String, _ asset: PHAsset) {
        self.selectedAssets.append(asset)
    }
    
    func assetFromAlbumDeselected(_ albumName: String, _ asset: PHAsset) {
        self.selectedAssets.remove(at: self.selectedAssets.firstIndex(of: asset)!)
    }
    
    func finishedPicking() {
        self.delegate?.selectedAssets(self.selectedAssets)
    }
    
    //MARK: PhotosAssetChange
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        albumListArray = MediaManager.shared.getAllMediaFolders()
        DispatchQueue.main.async {
            self.albumsTableView.reloadData()
            
            let vc:UIViewController = (self.navigationController?.viewControllers.last)!
            
            if vc is AlbumDetailsViewController {
                self.selectedAlbum = (self.albumListArray?[self.selectedIndex!.row])
                self.selectedResult = self.selectedAlbum!.allAssetsFromCollection()
                self.detailsViewController!.albumResult = self.selectedResult
                self.detailsViewController!.selectedItems = self.selectedAssets
            }
        }
    }
}

