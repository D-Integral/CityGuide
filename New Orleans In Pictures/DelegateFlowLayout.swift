//
//  DelegateFlowLayout.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 22.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//


import UIKit

extension GalleryVC {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        println("\nsizeForItemAtIndexPath CALLED...")
        println("IndexPath: \(indexPath.row), \(indexPath.section)")
        
        let size = indexPath.row == 0 ? Constants.sizeForLargeCell : Constants.sizeForSmallCell

        println("Size: \(size)")
        
        return size
    }
    


    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return CGFloat(10.0)
//    }

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return CGFloat(10.0)
//    }
}