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
    let headerSize = CGSizeMake(300.0, 50.0)
    
    var margin: CGFloat!
    var itemSizeSmall: CGSize!
    var numberOfSections: Int!
    var numberOfItemsInSection = [Int : Int]()
    var numberOfItemsInRow: Int!
    var heightOfSection = [Int : CGFloat]()
    
    var currentCellOrigin: CGPoint!
    
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
        
        currentCellOrigin = CGPointMake(margin, headerSize.height + marginBetweenCells)
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
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        attributes.size = indexPath.row == 0 ? itemSizeLarge : itemSizeSmall
        
        switch indexPath.section {
        case 0:
            if isFirstCellAt(indexPath) {
                attributes.center = centerForLargeCell()
                currentCellOrigin.x += itemSizeLarge.width + marginBetweenCells
            } else {
                if cellFitsWithinLine() {
                    if !isRowEvenAt(indexPath) {
                        attributes.center = centerForSmallCell()
                        currentCellOrigin.y += itemSizeSmall.height + marginBetweenCells
                    } else {
                        attributes.center = centerForSmallCell()
                        currentCellOrigin.x += itemSizeSmall.width + marginBetweenCells
                        currentCellOrigin.y -= itemSizeSmall.height + marginBetweenCells
                    }
                } else {
                    currentCellOrigin.x = margin
                    currentCellOrigin.y += itemSizeLarge.height + marginBetweenCells
                    
                    attributes.center = centerForSmallCell()
                    
                    currentCellOrigin.y += itemSizeSmall.height + marginBetweenCells
                }
            }
            
            if isCellLastInSectionAt(indexPath) {
                currentCellOrigin.x = margin
                currentCellOrigin.y = heightOfSection[indexPath.section]! + headerSize.height + marginBetweenCells
            }
        case 1:
            if isFirstCellAt(indexPath) {
                attributes.center = centerForLargeCell()
                currentCellOrigin.x += itemSizeLarge.width + marginBetweenCells
            } else {
                if cellFitsWithinLine() {
                    if !isRowEvenAt(indexPath) {
                        attributes.center = centerForSmallCell()
                        currentCellOrigin.y += itemSizeSmall.height + marginBetweenCells
                    } else {
                        attributes.center = centerForSmallCell()
                        currentCellOrigin.x += itemSizeSmall.width + marginBetweenCells
                        currentCellOrigin.y -= itemSizeSmall.height + marginBetweenCells
                    }
                } else {
                    currentCellOrigin.x = margin
                    currentCellOrigin.y += itemSizeLarge.height + marginBetweenCells
                    
                    attributes.center = centerForSmallCell()
                    
                    currentCellOrigin.y += itemSizeSmall.height + marginBetweenCells
                }
            }
            
            if isCellLastInSectionAt(indexPath) {
                currentCellOrigin.x = margin
                currentCellOrigin.y = heightOfSection[indexPath.section - 1]! + heightOfSection[indexPath.section]! + headerSize.height + marginBetweenCells
            }

        case 2:
            if isFirstCellAt(indexPath) {
                attributes.center = centerForLargeCell()
                currentCellOrigin.x += itemSizeLarge.width + marginBetweenCells
            } else {
                if cellFitsWithinLine() {
                    if !isRowEvenAt(indexPath) {
                        attributes.center = centerForSmallCell()
                        currentCellOrigin.y += itemSizeSmall.height + marginBetweenCells
                    } else {
                        attributes.center = centerForSmallCell()
                        currentCellOrigin.x += itemSizeSmall.width + marginBetweenCells
                        currentCellOrigin.y -= itemSizeSmall.height + marginBetweenCells
                    }
                } else {
                    currentCellOrigin.x = margin
                    currentCellOrigin.y += itemSizeLarge.height + marginBetweenCells
                    
                    attributes.center = centerForSmallCell()
                    
                    currentCellOrigin.y += itemSizeSmall.height + marginBetweenCells
                }
            }

        default: break
        }
    
        //println("Cell attributes at indexpath: row \(indexPath.row), section \(indexPath.section)")
        return attributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
        
        attributes.size = headerSize
        if elementKind == UICollectionElementKindSectionHeader {
            switch indexPath.section {
            case 0:
                attributes.center = CGPointMake(self.collectionView!.frame.size.width / 2, headerSize.height / 2)
            case 1:
                attributes.center = CGPointMake(self.collectionView!.frame.size.width / 2, heightOfSection[0]! + headerSize.height / 2)
            case 2:
                attributes.center = CGPointMake(self.collectionView!.frame.size.width / 2, heightOfSection[0]! + heightOfSection[1]! + headerSize.height / 2)
            default: break
            }
        }
            
        return attributes
    }
    
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
        
        size.height += marginBetweenCells
        
        println("Content size: width \(size.width), height \(size.height)")
        return size
    }
    
    func isFirstCellAt(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == 0 ? true : false
    }
    
    func isRowEvenAt(indexPath: NSIndexPath) -> Bool {
        return indexPath.row % 2 == 0 ? true : false
    }
    
    func centerForLargeCell() -> CGPoint {
        return CGPointMake(currentCellOrigin.x + itemSizeLarge.width / 2, currentCellOrigin.y + itemSizeLarge.height / 2)
    }
    
    func centerForSmallCell() -> CGPoint {
        return CGPointMake(currentCellOrigin.x + itemSizeSmall.width / 2, currentCellOrigin.y + itemSizeSmall.height / 2)
    }
    
    func cellFitsWithinLine() -> Bool {
        return self.collectionView!.frame.size.width - currentCellOrigin.x > itemSizeSmall.width + marginBetweenCells ? true : false
    }
    
    func isCellLastInSectionAt(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == numberOfItemsInSection[indexPath.section]! - 1 ? true : false
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
