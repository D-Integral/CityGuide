//
//  CustomCollectionViewLayout.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 27.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
    
class CustomFlowLayout: UICollectionViewFlowLayout {
    
    let cellSizeProportion: CGFloat = 1.33
    let marginBetweenCells: CGFloat = 10.0
    let headerSize = CGSizeMake(300.0, 50.0)
    
    var marginBetweenDoubleRows: CGFloat!
    var screenWidth: CGFloat!
    var itemSizeLarge: CGSize!
    var margin: CGFloat!
    var itemSizeSmall: CGSize!
    var numberOfSections: Int!
    var numberOfItemsInSection = [Int : Int]()
    var numberOfItemsInRow: Int!
    var heightOfSection = [Int : CGFloat]()
    
    var currentCellOrigin: CGPoint!
    
    //MARK: Main overriden mathods
    
    override func prepareLayout() {
        super.prepareLayout()
        
        setInitialValuesForProperties()
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
                    allElementsAttributes![index] = layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: layoutAttributes.indexPath)
                }
            case .Cell:
                allElementsAttributes![index] = layoutAttributesForItemAtIndexPath(layoutAttributes.indexPath)
            case .DecorationView: break
            }
        }
        
        return allElementsAttributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        attributes.size = indexPath.row == 0 ? itemSizeLarge : itemSizeSmall
        attributes.center = centerForCellAt(indexPath)
        
        if isCellLastInSectionAt(indexPath) {
            currentCellOrigin.x = margin
            
            switch indexPath.section {
            case 0: currentCellOrigin.y = heightOfSection[indexPath.section]! + headerSize.height + marginBetweenCells
            case 1:
                currentCellOrigin.y = heightOfSection[indexPath.section - 1]! + heightOfSection[indexPath.section]! + headerSize.height + marginBetweenCells
            default: break
            }
        }
    
        //println("Cell attributes at indexpath: row \(indexPath.row), section \(indexPath.section)")
        return attributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
        
        if elementKind == UICollectionElementKindSectionHeader {
            attributes.size = headerSize
            attributes.center = centerForHeaderAt(indexPath)
        }
            
        return attributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true //CGSizeEqualToSize(newBounds.size, self.collectionView!.frame.size)//!CGRectIntersectsRect(newBounds, self.collectionView!.frame)//!CGSizeEqualToSize(newBounds.size, self.collectionView!.frame.size)
    }

    //MARK: Private helper methods
    
    func centerForHeaderAt(indexPath: NSIndexPath) -> CGPoint {
        var center: CGPoint!
        
        switch indexPath.section {
        case 0: center =  CGPointMake(screenWidth / 2, headerSize.height / 2)
        case 1: center = CGPointMake(screenWidth / 2, heightOfSection[0]! + headerSize.height / 2)
        case 2: center = CGPointMake(screenWidth / 2, heightOfSection[0]! + heightOfSection[1]! + headerSize.height / 2)
        default: break
        }
        
        return center
    }
    
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
        return self.collectionView!.frame.size.width - currentCellOrigin.x > itemSizeSmall.width /*+ marginBetweenCells*/ ? true : false
    }
    
    func isCellLastInSectionAt(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == numberOfItemsInSection[indexPath.section]! - 1 ? true : false
    }
    
    func setInitialValuesForProperties() {
        screenWidth = currentScreenWidth()
        margin = 0
        println("Screen width: \(screenWidth), Screen margin: \(margin)")
        
        itemSizeSmall = sizeForSmallItem()
        itemSizeLarge = sizeForLargeitem()
        println("Size of small item: width \(itemSizeSmall.width), height: \(itemSizeSmall.height)")
        println("Size of large item: width \(itemSizeLarge.width), height: \(itemSizeLarge.height)")
        
        marginBetweenDoubleRows = itemSizeSmall.height / 4
        
        println("Margin between double rows: \(marginBetweenDoubleRows)")
        
        numberOfSections = self.collectionView!.numberOfSections()
        
        calculateNumberOfItemsInSections()
        
        numberOfItemsInRow = itemsInRow()
        println("Number of items in the row: \(numberOfItemsInRow)")
        
        calculateSectionsHeights()
        
        currentCellOrigin = initialCellOrigin()
    }
    
    func calculateSectionsHeights() {
        for section in 0..<numberOfSections {
            heightOfSection[section] = heightOfSection(section)
            println("Section \(section) height: \(heightOfSection[section])")
        }
    }
    
    func heightOfSection(section: Int) -> CGFloat {
        
        var height: CGFloat!
        
        if numberOfItemsInSection[section]! == 0 {return 0.0}
        
        //+3 need to consider the first large item
        let numberOfDoubleRowsInSection = Int((numberOfItemsInSection[section]! + 3) / (2 * numberOfItemsInRow))
        
        println("Number of double rows in section \(section): \(numberOfDoubleRowsInSection)")
        
        switch (numberOfItemsInSection[section]! + 3) % (2 * numberOfItemsInRow) {
        case 0:
            height = headerSize.height + marginBetweenCells + (itemSizeLarge.height + marginBetweenDoubleRows) * CGFloat(numberOfDoubleRowsInSection) - marginBetweenDoubleRows + marginBetweenCells
        case 1:
            height = headerSize.height + marginBetweenCells + (itemSizeLarge.height + marginBetweenDoubleRows) * CGFloat(numberOfDoubleRowsInSection) + itemSizeSmall.height + marginBetweenCells
        default:
            height = headerSize.height + marginBetweenCells + (itemSizeLarge.height + marginBetweenDoubleRows) * CGFloat(numberOfDoubleRowsInSection + 1) - marginBetweenDoubleRows + marginBetweenCells
        }
        
        return height
    }
    
    func initialCellOrigin() -> CGPoint {
        return CGPointMake(margin, headerSize.height + marginBetweenCells)
    }
    
    func itemsInRow() -> Int {
        return Int((screenWidth - 2 * margin) / itemSizeSmall.width)
    }
    
    func calculateNumberOfItemsInSections() {
        for section in 0..<numberOfSections {
            numberOfItemsInSection[section] = self.collectionView!.numberOfItemsInSection(section)
            println("Number of items in section \(section): \(numberOfItemsInSection[section])")
        }
    }
    
    func currentScreenWidth() -> CGFloat {
        return self.collectionView!.frame.size.width
    }
    
    func sizeForSmallItem() -> CGSize {
        let width = (screenWidth - 2 * marginBetweenCells) / 3
        return CGSizeMake(width, width * cellSizeProportion)
    }
    
    func sizeForLargeitem() -> CGSize {
        let width = 2 * itemSizeSmall.width + marginBetweenCells
        let height = 2 * itemSizeSmall.height + marginBetweenCells
        return CGSizeMake(width, height)
    }
    
    func centerForCellAt(indexPath: NSIndexPath) -> CGPoint {
        var center: CGPoint!
        
        if isFirstCellAt(indexPath) {
            center = centerForLargeCell()
            currentCellOrigin.x += itemSizeLarge.width + marginBetweenCells
        } else {
            if cellFitsWithinLine() {
                if !isRowEvenAt(indexPath) {
                    center = centerForSmallCell()
                    currentCellOrigin.y += itemSizeSmall.height + marginBetweenCells
                } else {
                    center = centerForSmallCell()
                    currentCellOrigin.x += itemSizeSmall.width + marginBetweenCells
                    currentCellOrigin.y -= itemSizeSmall.height + marginBetweenCells
                }
            } else {
                currentCellOrigin.x = margin
                currentCellOrigin.y += itemSizeLarge.height + marginBetweenDoubleRows
                
                center = centerForSmallCell()
                
                currentCellOrigin.y += itemSizeSmall.height + marginBetweenCells
            }
        }
        
        return center
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
