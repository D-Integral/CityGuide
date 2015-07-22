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
        
        var size: CGSize!
        switch indexPath.section {
        case 0: size = (wantToSee.count == 0) ? CGSizeZero : Constants.sizeForCell
        case 1: size = (unchecked.count == 0) ? CGSizeZero : Constants.sizeForCell
        case 2: size = (alreadySeen.count == 0) ? CGSizeZero : Constants.sizeForCell
        default: break
        }
        
        return size
    }
}
