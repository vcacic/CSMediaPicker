//
//  AlbumDetailsViewController.swift
//  CSMediaPickingFlow
//
//  Created by CloverField on 23/10/2019.
//  Copyright © 2019 CloverField. All rights reserved.
//

import UIKit
import Photos

protocol AlbumDetailsDelegate {
    
    func assetFromAlbumSelected(_ albumName:String, _ asset:PHAsset)
    func assetFromAlbumDeselected(_ albumName:String, _ asset:PHAsset)
    func finishedPicking()
    
}

class AlbumDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellIdentifier = "mediaCell"
    let cellName = "MediaCollectionCell"
    let cellHeight: CGFloat = UIScreen.main.bounds.size.width/4 - 4
    var delegate: AlbumDetailsDelegate? = nil
    var scrollOnInit:Bool = false
    var assetCountLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    var doneButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
    var barButton:UIBarButtonItem?

    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    var albumName:String?{
        didSet{
                setNavigation()
        }
    }
    
    var albumResult:PHFetchResult<PHAsset>?{
        didSet{
            setData()
        }
    }
    
    var mediaArray:[PHAsset] = []
    var selectedItems:[PHAsset] = []{
        didSet{
            assetCountLabel.text = String("\(self.selectedItems.count) Items Selected ")
            if oldValue.count == 0  && self.selectedItems.count == 1{
                self.navigationController?.setToolbarHidden(false, animated: true)
                self.navigationItem.rightBarButtonItem = self.barButton
                
            }
            if oldValue.count == 1 && self.selectedItems.count == 0{
                self.navigationController?.setToolbarHidden(true, animated: true)
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: MediaCollectionCell.self)
        let customCell = UINib(nibName: cellName, bundle: bundle)
        albumCollectionView.register(customCell, forCellWithReuseIdentifier: cellIdentifier)
        albumCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context:nil)
        albumCollectionView.allowsMultipleSelection = true
        
        assetCountLabel.textAlignment = .center
        assetCountLabel.textColor = .label
        
        var toolbarArray:[UIBarButtonItem] = []
        let barItem:UIBarButtonItem = UIBarButtonItem(customView: assetCountLabel)
        toolbarArray.append(barItem)
        self.setToolbarItems(toolbarArray, animated: false)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(self.onDone), for: .touchUpInside)
        barButton = UIBarButtonItem(customView: doneButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedItems.count > 0{
            self.navigationController?.setToolbarHidden(false, animated: true)
            self.navigationItem.rightBarButtonItem = self.barButton
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.albumCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView, observedObject == self.albumCollectionView{
            let contentSize:CGSize = self.albumCollectionView.collectionViewLayout.collectionViewContentSize
            if contentSize.height > self.albumCollectionView.bounds.size.height {
                if !scrollOnInit{
                    scrollOnInit = true
                    self.albumCollectionView.scrollToItem(at: IndexPath(item: self.mediaArray.count-1, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
                }
                
            }
        }
    }
    
    @objc func onDone(){
        delegate?.finishedPicking()
    }
    
    func setNavigation(){
        
        self.navigationItem.title = albumName
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
    }
    
    func setData(){
        
        mediaArray = fetchAssets()
        if albumCollectionView != nil{
            albumCollectionView.reloadData()
        }
    }
    
    func fetchAssets() -> [PHAsset]{
        
        var assets:[PHAsset] = []
        albumResult?.enumerateObjects{ (asset, index, stop) in
            assets.append(asset)
            
        }
        return assets
    }
    
// MARK:CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mediaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let media:PHAsset = mediaArray[indexPath.row]
        let cell:MediaCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MediaCollectionCell
        cell.cellHeight = cellHeight
        cell.asset = media
        
        if selectedItems.contains(media){
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHeight, height:cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let media:PHAsset = mediaArray[indexPath.row]
        self.delegate?.assetFromAlbumSelected(albumName!, media)
        self.selectedItems.append(media)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let media:PHAsset = mediaArray[indexPath.row]
        self.delegate?.assetFromAlbumDeselected(albumName!, media)
        self.selectedItems.remove(at: self.selectedItems.firstIndex(of: media)!)
    }
    
}
