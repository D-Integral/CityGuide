//
//  CustomCollectionViewLayout.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 27.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
    
class CustomFlowLayout: UICollectionViewFlowLayout {
    
    let itemSizeLarge = CGSizeMake(150, 195)
    let marginBetweenCells: CGFloat = 10.0
    let headerSize = CGSizeMake(50.0, 50.0)
    
    var margin: CGFloat!
    var itemSizeSmall: CGSize!
    var numberOfSections: Int!
    var numberOfItemsInSection = [Int : Int]()
    var numberOfItemsInRow: Int!
    var heightOfSection = [Int : CGFloat]()
    
    
    override func prepareLayout() {
        super.prepareLayout()
        
        margin = self.collectionView!.frame.size.width * 0.05
        println("Screen width: \(self.collectionView!.frame.size.width), Screen margin: \(margin)")
        itemSizeSmall = CGSizeMake((itemSizeLarge.width - marginBetweenCells) / 2, (itemSizeLarge.height - marginBetweenCells) / 2)
        println("Size of small item: width \(itemSizeSmall.width), height: \(itemSizeSmall.height)")
        
        numberOfSections = self.collectionView!.numberOfSections()
        println("Number of sections: \(numberOfSections)")
        
        for section in 0..<numberOfSections {
            numberOfItemsInSection[section] = self.collectionView!.numberOfItemsInSection(section)
            println("Number of items in section \(section): \(numberOfItemsInSection[section])")
        }
        
        numberOfItemsInRow = Int((self.collectionView!.frame.size.width - 2 * margin) / (itemSizeSmall.width + marginBetweenCells))
        println("Number of items in the row: \(numberOfItemsInRow)")
        
        for section in 0..<numberOfSections {
            
            //+3 need to consider the first large item
            let numberOfDoubleRowsInSection: Int = Int((numberOfItemsInSection[section]! + 3) / (2 * numberOfItemsInRow))
            
            switch (numberOfItemsInSection[section]! + 3) % (2 * numberOfItemsInRow) {
            case 0:
                heightOfSection[section] = headerSize.height + marginBetweenCells + (itemSizeLarge.height + marginBetweenCells) * CGFloat(numberOfDoubleRowsInSection)
            case 1:
                heightOfSection[section] = headerSize.height + marginBetweenCells + (itemSizeLarge.height + marginBetweenCells) * CGFloat(numberOfDoubleRowsInSection) + itemSizeSmall.height + marginBetweenCells
            default:
                heightOfSection[section] = headerSize.height + marginBetweenCells + (itemSizeLarge.height + marginBetweenCells) * CGFloat(numberOfDoubleRowsInSection + 1)
            }
            
            println("Section \(section) height: \(heightOfSection[section])")
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return contentSize()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var allElementsAttributes = super.layoutAttributesForElementsInRect(rect) as? [UICollectionViewLayoutAttributes]
        if allElementsAttributes == nil { return nil }
        
        for (index, layoutAttributes) in enumerate(allElementsAttributes!) {
            switch layoutAttributes.representedElementCategory {
            case .SupplementaryView:
                if layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader {
                    let newLayoutAttributes = layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: layoutAttributes.indexPath)
                    allElementsAttributes![index] = newLayoutAttributes
                }
                
            case .Cell:
                let newLayoutAttributes = layoutAttributesForItemAtIndexPath(layoutAttributes.indexPath)
                allElementsAttributes![index] = newLayoutAttributes
            case .DecorationView: break
            }
        }
        
        return allElementsAttributes
    }
    
    
//    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
//        
//        
//    }
//    
//    
//    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
//        
//    }
//    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    
    
    //MARK: Private helper methods
    
    func contentSize() -> CGSize {
        var size = CGSizeZero
        size.width = self.collectionView!.frame.size.width
        for section in 0..<numberOfSections {
            size.height += heightOfSection[section]!
        }
        
        println("Content size: width \(size.width), height \(size.height)")
        return size
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Animation
    //    override func initialLayoutAttributesForAppearingDecorationElementOfKind(elementKind: String, atIndexPath decorationIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    //
    //    }
    //
    //    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    //        
    //    }

}
