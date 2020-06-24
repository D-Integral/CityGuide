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
        static let sizeForSmallCell = CGSize(width: 150.0, height: 203.0)
        static let headerSize = CGSize(width: 300.0, height: 50.0)
        static let marginBetweenRows: CGFloat = 10.0
        static let sectionInsetLeft: CGFloat = 5.0
        static let sectionInsetRight: CGFloat = 5.0
    }
    
    var attributesForItemsAtIndexPath: [IndexPath : UICollectionViewLayoutAttributes]!
    var attributesForHeadersAtIndexPath: [IndexPath : UICollectionViewLayoutAttributes]!
    var isCurrentRowFirst: Bool!
    var marginBetweenCells: CGFloat!
    var sizeForLargeCell: CGSize!
    
    //MARK: Main overriden methods
    
    override func prepare() {
        super.prepare()
        
        attributesForItemsAtIndexPath = [IndexPath : UICollectionViewLayoutAttributes]()
        attributesForHeadersAtIndexPath = [IndexPath : UICollectionViewLayoutAttributes]()
        
        isCurrentRowFirst = true
        
        marginBetweenCells = spaceBetweenCells()
        
        sizeForLargeCell = largeCellSize()
        
        calculateAttributesForItems()
        calculateAttributesForHeaders()
    }
    
    override var collectionViewContentSize : CGSize {
        return contentSize()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return [UICollectionViewLayoutAttributes](attributesForItemsAtIndexPath.values) + [UICollectionViewLayoutAttributes](attributesForHeadersAtIndexPath.values)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesForItemsAtIndexPath[indexPath]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return elementKind == UICollectionView.elementKindSectionHeader ? attributesForHeadersAtIndexPath[indexPath] : nil
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    //MARK: Private helper methods
    
    func spaceBetweenCells() -> CGFloat {
        return (currentScreenWidth() - Constants.sectionInsetLeft - Constants.sectionInsetRight - CGFloat(numberOfItemsInRow()) * Constants.sizeForSmallCell.width) / (CGFloat(numberOfItemsInRow()) - 1)
    }
    
    func largeCellSize() -> CGSize {
        return CGSize(width: Constants.sizeForSmallCell.width * 2 + marginBetweenCells, height: Constants.sizeForSmallCell.height * 2 + Constants.marginBetweenRows)
    }
    
    func isFirstCellAt(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 ? true : false
    }
    
    func isCellLastInSectionAt(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == self.collectionView!.numberOfItems(inSection: indexPath.section) - 1 ? true : false
    }
    
    func currentScreenWidth() -> CGFloat {
        return self.collectionView!.frame.size.width
    }
    
    func cellFitsWithinLineWithAttributes(_ attributes: UICollectionViewLayoutAttributes) -> Bool {
        
        return currentScreenWidth() - attributes.center.x - Constants.sectionInsetRight >= Constants.sizeForSmallCell.width / 2 ? true : false
    }
    
    func numberOfItemsInRow() -> Int {
        return Int((currentScreenWidth() - Constants.sectionInsetLeft - Constants.sectionInsetRight) / Constants.sizeForSmallCell.width)
    }
    
    func calculateAttributesForItems() {
        for section in 0..<self.collectionView!.numberOfSections {
            for row in 0..<self.collectionView!.numberOfItems(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                attributesForItemsAtIndexPath[indexPath] = attributesForItemWithIndexPath(indexPath)
            }
        }
    }
    
    func attributesForItemWithIndexPath(_ indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        
        let attributes = super.layoutAttributesForItem(at: indexPath)
        
        if !isFirstCellAt(indexPath) {
            
            let indexPathForPreviuosItem = IndexPath(row: indexPath.row - 1, section: indexPath.section)
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
    
    func heightOfSection(_ section: Int) -> CGFloat {
        let numberOfItems = self.collectionView!.numberOfItems(inSection: section)
        if numberOfItems == 0 { return 0.0 }
        
        let firstCellIndexPath = IndexPath(row: 0, section: section)
        let lastCellIndexPath = IndexPath(row: numberOfItems - 1, section: section)
        let firstCellTop = attributesForItemsAtIndexPath[firstCellIndexPath]!.frame.origin.y
        let lastCellBottom = max(attributesForItemsAtIndexPath[lastCellIndexPath]!.frame.maxY, attributesForItemsAtIndexPath[firstCellIndexPath]!.frame.maxY)
        
        return Constants.headerSize.height + (lastCellBottom - firstCellTop)
    }
    
    func contentSize() -> CGSize {
        
        var size = CGSize.zero
        size.width = self.collectionView!.frame.size.width
        
        for section in 0..<self.collectionView!.numberOfSections {
            size.height += heightOfSection(section)
        }
        
        size.height += 10.0
        
        return size
    }
    
    func calculateAttributesForHeaders() {
        for section in 0..<self.collectionView!.numberOfSections {
            let indexPath = IndexPath(row: 0, section: section)
            attributesForHeadersAtIndexPath[indexPath] = attributesForHeaderAtIndexPath(indexPath)
        }
    }
    
    func attributesForHeaderAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
        
        if self.collectionView!.numberOfItems(inSection: indexPath.section) == 0 { return nil }
        
        attributes.size = Constants.headerSize
        
        switch indexPath.section {
        case 0: attributes.center =  CGPoint(x: currentScreenWidth() / 2, y: Constants.headerSize.height / 2)
        case 1: attributes.center = CGPoint(x: currentScreenWidth() / 2, y: heightOfSection(0) + Constants.headerSize.height / 2)
        case 2: attributes.center = CGPoint(x: currentScreenWidth() / 2, y: heightOfSection(0) + heightOfSection(1) + Constants.headerSize.height / 2)
        default: break
        }
        
        return attributes
    }
}
