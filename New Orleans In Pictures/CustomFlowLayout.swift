//
//  CustomCollectionViewLayout.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 27.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    struct Constants {
        static let sizeForSmallCell = CGSizeMake(150.0, 203.0)
        static let headerSize = CGSizeMake(300.0, 100.0)
        static let marginBetweenRows: CGFloat = 10.0
        static let sectionInsetLeft: CGFloat = 5.0
        static let sectionInsetRight: CGFloat = 5.0
    }
    
    var attributesForItemsAtIndexPath: [NSIndexPath : UICollectionViewLayoutAttributes]!
    var attributesForHeadersAtIndexPath: [NSIndexPath : UICollectionViewLayoutAttributes]!
    var isCurrentRowFirst: Bool!
    var marginBetweenCells: CGFloat!
    var sizeForLargeCell: CGSize!
    
    //MARK: Main overriden methods
    
    override func prepareLayout() {
        super.prepareLayout()
        
        attributesForItemsAtIndexPath = [NSIndexPath : UICollectionViewLayoutAttributes]()
        attributesForHeadersAtIndexPath = [NSIndexPath : UICollectionViewLayoutAttributes]()
        
        isCurrentRowFirst = true
        
        marginBetweenCells = spaceBetweenCells()
        
        sizeForLargeCell = largeCellSize()
        
        calculateAttributesForItems()
        calculateAttributesForHeaders()
    }
    
    override func collectionViewContentSize() -> CGSize {
        return contentSize()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return [UICollectionViewLayoutAttributes](attributesForItemsAtIndexPath.values) + [UICollectionViewLayoutAttributes](attributesForHeadersAtIndexPath.values)
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesForItemsAtIndexPath[indexPath]
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        return elementKind == UICollectionElementKindSectionHeader ? attributesForHeadersAtIndexPath[indexPath] : nil
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    //MARK: Private helper methods
    
    func spaceBetweenCells() -> CGFloat {
        return (currentScreenWidth() - Constants.sectionInsetLeft - Constants.sectionInsetRight - CGFloat(numberOfItemsInRow()) * Constants.sizeForSmallCell.width) / (CGFloat(numberOfItemsInRow()) - 1)
    }
    
    func largeCellSize() -> CGSize {
        return CGSize(width: Constants.sizeForSmallCell.width * 2 + marginBetweenCells, height: Constants.sizeForSmallCell.height * 2 + Constants.marginBetweenRows)
    }
  
    func isFirstCellAt(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == 0 ? true : false
    }
    
    func isCellLastInSectionAt(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == self.collectionView!.numberOfItemsInSection(indexPath.section) - 1 ? true : false
    }
    
    func currentScreenWidth() -> CGFloat {
        return self.collectionView!.frame.size.width
    }
    
    func cellFitsWithinLineWithAttributes(attributes: UICollectionViewLayoutAttributes) -> Bool {
        
        return currentScreenWidth() - attributes.center.x - Constants.sectionInsetRight >= Constants.sizeForSmallCell.width / 2 ? true : false
    }
    
    func numberOfItemsInRow() -> Int {
        return Int((currentScreenWidth() - Constants.sectionInsetLeft - Constants.sectionInsetRight) / Constants.sizeForSmallCell.width)
    }
    
    func calculateAttributesForItems() {
        for section in 0..<self.collectionView!.numberOfSections() {
            for row in 0..<self.collectionView!.numberOfItemsInSection(section) {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                attributesForItemsAtIndexPath[indexPath] = attributesForItemWithIndexPath(indexPath)
            }
        }
    }
    
    func attributesForItemWithIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes {
        
       let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        
        if !isFirstCellAt(indexPath) {
            
            let indexPathForPreviuosItem = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            let previousItemAttributes = attributesForItemsAtIndexPath[indexPathForPreviuosItem]
            let previousItemCenter = previousItemAttributes!.center
            let previousItemSize = previousItemAttributes!.size
            
            if isFirstCellAt(indexPathForPreviuosItem) {
                attributes!.center.x = previousItemCenter.x + previousItemSize.width / 2 + marginBetweenCells + Constants.sizeForSmallCell.width / 2
                attributes!.center.y = previousItemCenter.y - Constants.marginBetweenRows / 2 - Constants.sizeForSmallCell.height / 2
            } else {
                attributes!.center.x = previousItemCenter.x + previousItemSize.width / 2 + marginBetweenCells + Constants.sizeForSmallCell.width / 2
                attributes!.center.y = previousItemCenter.y
                
                if !cellFitsWithinLineWithAttributes(attributes!) {
                    if isCurrentRowFirst == true {
                        attributes!.center.x = Constants.sectionInsetLeft + sizeForLargeCell.width + marginBetweenCells + Constants.sizeForSmallCell.width / 2
                        attributes!.center.y = previousItemCenter.y + Constants.sizeForSmallCell.height + Constants.marginBetweenRows
                        isCurrentRowFirst = false
                    } else {
                        attributes!.center.x = Constants.sectionInsetLeft + Constants.sizeForSmallCell.width / 2
                        attributes!.center.y = previousItemCenter.y + Constants.sizeForSmallCell.height + Constants.marginBetweenRows
                    }
                }
            }
        } else {
            attributes!.center.x = Constants.sectionInsetLeft + sizeForLargeCell.width / 2
            
            switch indexPath.section {
            case 0: attributes!.center.y = Constants.headerSize.height + sizeForLargeCell.height / 2
            case 1: attributes!.center.y = heightOfSection(0) + Constants.headerSize.height + sizeForLargeCell.height / 2
            case 2: attributes!.center.y = heightOfSection(1) + heightOfSection(0) + Constants.headerSize.height + sizeForLargeCell.height / 2
            default: break
            }
        }
        
        if isCellLastInSectionAt(indexPath) {
            isCurrentRowFirst = true
        }
        
        return attributes!
    }
    
    func heightOfSection(section: Int) -> CGFloat {
        let numberOfItems = self.collectionView!.numberOfItemsInSection(section)
        if numberOfItems == 0 { return 0.0 }
        
        let firstCellIndexPath = NSIndexPath(forRow: 0, inSection: section)
        let lastCellIndexPath = NSIndexPath(forRow: numberOfItems - 1, inSection: section)
        let firstCellTop = attributesForItemsAtIndexPath[firstCellIndexPath]!.frame.origin.y
        let lastCellBottom = max(CGRectGetMaxY(attributesForItemsAtIndexPath[lastCellIndexPath]!.frame), CGRectGetMaxY(attributesForItemsAtIndexPath[firstCellIndexPath]!.frame))
    
        return Constants.headerSize.height + (lastCellBottom - firstCellTop)
    }
    
    func contentSize() -> CGSize {
        
        var size = CGSizeZero
        size.width = self.collectionView!.frame.size.width
        
        for section in 0..<self.collectionView!.numberOfSections() {
            size.height += heightOfSection(section)
        }
        
        size.height += 10.0
        
        print("Content size: width \(size.width), height \(size.height)")
        
        return size
    }
    
    func calculateAttributesForHeaders() {
        for section in 0..<self.collectionView!.numberOfSections() {
            let indexPath = NSIndexPath(forRow: 0, inSection: section)
            attributesForHeadersAtIndexPath[indexPath] = attributesForHeaderAtIndexPath(indexPath)
        }
    }
    
    func attributesForHeaderAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: indexPath)
    
        if self.collectionView!.numberOfItemsInSection(indexPath.section) == 0 { return nil }
        
        attributes.size = Constants.headerSize
        
        switch indexPath.section {
        case 0: attributes.center =  CGPointMake(currentScreenWidth() / 2, Constants.headerSize.height / 2)
        case 1: attributes.center = CGPointMake(currentScreenWidth() / 2, heightOfSection(0) + Constants.headerSize.height / 2)
        case 2: attributes.center = CGPointMake(currentScreenWidth() / 2, heightOfSection(0) + heightOfSection(1) + Constants.headerSize.height / 2)
        default: break
        }
            
        return attributes
    }
}
