//
//  CSMediaPicker.swift
//  CSMediaPicker
//
//  Created by CloverField on 04/11/2019.
//  Copyright © 2019 CloverField. All rights reserved.
//

import UIKit


public class CSMediaPicker{
    
    public static func start() -> AlbumListViewController{
        
    
        let bundle = Bundle(for: AlbumListViewController.self.classForCoder())
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc: AlbumListViewController = storyboard.instantiateViewController(identifier: "albumListVC") 
        return vc
    }
    
}
