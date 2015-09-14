//
//  PictureCell.swift
//  New Orleans In Pictures
//
//  Created by Skorokhod, Dmytro on 4/24/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationDataView: ViewForLocationData!
    
//    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes! {
//        var attributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
//        
//        if attributes.indexPath.row == 0 {
//            attributes.size = sizeForLargeItem()
//        } else {
//            attributes.size = sizeForSmallItem()
//        }
//        
//        return attributes
//    }
//    
//    func sizeForSmallItem() -> CGSize {
//        
//        let screenWidth: CGFloat = 768.0 //self.collectionView!.frame.size.width
//        let cellSizeProportion: CGFloat = 1.33
//        let marginBetweenCells: CGFloat = 10.0
//        let width = Int((screenWidth - 2 * marginBetweenCells) / 3)
//        
//        return CGSizeMake(CGFloat(width), CGFloat(width) * cellSizeProportion)
//    }
//    
//    func sizeForLargeItem() -> CGSize {
//        
//        let sizeSmall = sizeForSmallItem()
//        let marginBetweenCells: CGFloat = 10.0
//        let width = 2 * sizeSmall.width + marginBetweenCells
//        let height = 2 * sizeSmall.height + marginBetweenCells
//        
//        return CGSizeMake(width, height)
//    }

}
