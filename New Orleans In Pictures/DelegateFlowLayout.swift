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
        
        return indexPath.row == 0 ? sizeForLargeItem() : sizeForSmallItem()
    }
    
    func sizeForSmallItem() -> CGSize {
        
        let screenWidth = self.collectionView!.frame.size.width
        let cellSizeProportion: CGFloat = 1.33
        let marginBetweenCells: CGFloat = 10.0
        let width = Int((screenWidth - 2 * marginBetweenCells) / 3)
        
        return CGSizeMake(CGFloat(width), CGFloat(width) * cellSizeProportion)
    }
    
    func sizeForLargeItem() -> CGSize {
        
        let sizeSmall = sizeForSmallItem()
        let marginBetweenCells: CGFloat = 10.0
        let width = 2 * sizeSmall.width + marginBetweenCells
        let height = 2 * sizeSmall.height + marginBetweenCells
        
        return CGSizeMake(width, height)
    }

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        
//        let margin: CGFloat = 10.0
//        
//        return UIEdgeInsets(top: margin, left: 0.0, bottom: margin, right: 0.0)
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return CGFloat(10.0)
//    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return CGFloat(10.0)
//    }
}