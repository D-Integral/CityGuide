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
        
//        println("\nsizeForItemAtIndexPath CALLED...")
//        println("IndexPath: \(indexPath.row), \(indexPath.section)")
        
        let size = indexPath.row == 0 ? /*Constants.sizeForLargeCell*/largeCellSize() : Constants.sizeForSmallCell

        //println("Size: \(size)")
        
        return size
    }
    
    func largeCellSize() -> CGSize {
        let marginBetweenCells = (self.collectionView!.frame.size.width - 5 - 5 - CGFloat(numberOfItemsInRow()) * Constants.sizeForSmallCell.width) / (CGFloat(numberOfItemsInRow()) - 1)
        
        return CGSize(width: Constants.sizeForSmallCell.width * 2 + marginBetweenCells, height: Constants.sizeForSmallCell.height * 2 + 10)
    }
    
    func numberOfItemsInRow() -> Int {
        return Int((self.collectionView!.frame.size.width - 5 - 5) / Constants.sizeForSmallCell.width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    }
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return CGFloat(10.0)
//    }

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return CGFloat(10.0)
//    }
}