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
        static let headerSize = CGSizeMake(300.0, 50.0)
    }
    
    var attributesForItemAtIndexPath = [NSIndexPath : UICollectionViewLayoutAttributes]()
    var isCurrentRowFirst: Bool!
    var marginBetweenCells: CGFloat!
    var marginBetweenRows: CGFloat!
    var sectionInsetLeft: CGFloat!
    var sectionInsetRight: CGFloat!
    var sizeForLargeCell: CGSize!
    
    //MARK: Main overriden methods
    
    override func prepareLayout() {
        super.prepareLayout()
        
        //println("\nPREPARE LAYOUT CALLED...\n")
        sectionInsetLeft = 5.0
        sectionInsetRight = 5.0
        marginBetweenRows = 10.0
        
        isCurrentRowFirst = true
        marginBetweenCells = (currentScreenWidth() - sectionInsetLeft - sectionInsetRight - CGFloat(numberOfItemsInRow()) * Constants.sizeForSmallCell.width) / (CGFloat(numberOfItemsInRow()) - 1)
        
        println("MarginBetweenCells: \(marginBetweenCells)")
        
        
        sizeForLargeCell = largeCellSize()
        
        //println("\nPREPARE LAYOUT FINISHED...\n")
    }
    
//    override func collectionViewContentSize() -> CGSize {
//        return contentSize()
//    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        println("\nlayoutAttributesForElementsInRect CALLED...")
        println("Rect: originX \(rect.origin.x), originY \(rect.origin.y)")
        println("Rect: width \(rect.width), height \(rect.height)")
        
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
        
//        println("\nlayoutAttributesForItemAtIndexPath CALLED...")
//        println("Indexpath: row \(indexPath.row), section \(indexPath.section)")
        
        var attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        
        if !isFirstCellAt(indexPath) {
            
            let indexPathForPreviuosItem = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            let previousItemAttributes = attributesForItemAtIndexPath[indexPathForPreviuosItem]
            let previousItemCenter = previousItemAttributes!.center
            let previousItemSize = previousItemAttributes!.size
            
            if isFirstCellAt(indexPathForPreviuosItem) {
                attributes.center.x = previousItemCenter.x + previousItemSize.width / 2 + marginBetweenCells + Constants.sizeForSmallCell.width / 2
                attributes.center.y = previousItemCenter.y - marginBetweenRows / 2 - Constants.sizeForSmallCell.height / 2
            } else {
                attributes.center.x = previousItemCenter.x + previousItemSize.width / 2 + marginBetweenCells + Constants.sizeForSmallCell.width / 2
                attributes.center.y = previousItemCenter.y
                
                if !cellFitsWithinLineWithAttributes(attributes) {
                    if isCurrentRowFirst == true {
                        attributes.center.x = sectionInsetLeft + sizeForLargeCell.width + marginBetweenCells + Constants.sizeForSmallCell.width / 2
                        attributes.center.y = previousItemCenter.y + Constants.sizeForSmallCell.height + marginBetweenRows
                        isCurrentRowFirst = false
                    } else {
                        attributes.center.x = sectionInsetLeft + Constants.sizeForSmallCell.width / 2
                        attributes.center.y = previousItemCenter.y + Constants.sizeForSmallCell.height + marginBetweenRows
                    }
                }
            }
        }
        
        attributesForItemAtIndexPath[indexPath] = attributes
        
        println("\nlayoutAttributesForItemAtIndexPath: indexPath(\(indexPath.row),\(indexPath.section))")
        println("Size: width \(attributes.size.width), height \(attributes.size.height)")
        println("Center: (\(attributes.center.x),\(attributes.center.y))")
        
        return attributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        //        println("\nlayoutAttributesForSupplementaryViewOfKind CALLED...")
        //        println("Header indexpath: row \(indexPath.row), section \(indexPath.section)\n")
        
        var attributes = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
        
        if elementKind == UICollectionElementKindSectionHeader {
            attributes.size = Constants.headerSize
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        
        //println("\nLAYOUT INVALIDATED\n")
        
        return true//false
    }
    
    //MARK: Private helper methods
    
    func largeCellSize() -> CGSize {
        return CGSize(width: Constants.sizeForSmallCell.width * 2 + marginBetweenCells, height: Constants.sizeForSmallCell.height * 2 + marginBetweenRows)
    }
  
    func isFirstCellAt(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == 0 ? true : false
    }
    
    func currentScreenWidth() -> CGFloat {
        return self.collectionView!.frame.size.width
    }
    
    func cellFitsWithinLineWithAttributes(attributes: UICollectionViewLayoutAttributes) -> Bool {
        
        return currentScreenWidth() - attributes.center.x - sectionInsetRight >= Constants.sizeForSmallCell.width / 2 ? true : false
    }
    
    func numberOfItemsInRow() -> Int {
        return Int((currentScreenWidth() - sectionInsetLeft - sectionInsetRight) / Constants.sizeForSmallCell.width)
    }
    
    func frameForSection(section: Int) -> CGRect? {
        
        // Sanity check
        let numberOfItems = collectionView!.numberOfItemsInSection(section)
        if numberOfItems == 0 {
            return nil
        }
        
        // Get the index paths for the first and last cell in the section
        let firstIndexPath = NSIndexPath(forRow: 0, inSection: section)
        let lastIndexPath = numberOfItems == 0 ? firstIndexPath : NSIndexPath(forRow: numberOfItems - 1, inSection: section)
        
        // Work out the top of the first cell and bottom of the last cell
        var firstCellTop = layoutAttributesForItemAtIndexPath(firstIndexPath).frame.origin.y
        let lastCellBottom = CGRectGetMaxY(layoutAttributesForItemAtIndexPath(lastIndexPath).frame)
        
        // Build the frame for the section
        var frame = CGRectZero
        
        frame.size.width = collectionView!.bounds.size.width
        frame.origin.y = firstCellTop
        frame.size.height = lastCellBottom - firstCellTop
        
        // Increase the frame to allow space for the header
        frame.origin.y -= headerReferenceSize.height
        frame.size.height += headerReferenceSize.height
        
        // Increase the frame to allow space for an section insets
        frame.origin.y -= sectionInset.top
        frame.size.height += sectionInset.top
        
        frame.size.height += sectionInset.bottom
        
        return frame
    }
    
    func contentSize() -> CGSize {
    
        var size = CGSizeZero
        size.width = self.collectionView!.frame.size.width
        
        for section in 0..<self.collectionView!.numberOfSections() {
            if self.collectionView?.numberOfItemsInSection(section) != 0 {
                size.height += frameForSection(section)!.size.height
            }
        }
    
        println("Content size: width \(size.width), height \(size.height)")
    
        return size
    }
    




    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    let cellSizeProportion: CGFloat = 1.33
//    let marginBetweenCells: CGFloat = 10.0
//    let headerSize = CGSizeMake(300.0, 50.0)
//    
//    var marginBetweenDoubleRows: CGFloat!
//    var screenWidth: CGFloat!
//    var itemSizeLarge: CGSize!
//    var margin: CGFloat!
//    var itemSizeSmall: CGSize!
//    var numberOfSections: Int!
//    var numberOfItemsInSection = [Int : Int]()
//    var numberOfItemsInRow: Int!
//    var heightOfSection = [Int : CGFloat]()
//    
//    var centerForCellAtIndexPath = [NSIndexPath : CGPoint]()
//    var currentCellOrigin: CGPoint!
//
//    //MARK: Main overriden methods
//    
//    override func prepareLayout() {
//        super.prepareLayout()
//        
//        //println("\nPREPARE LAYOUT CALLED...\n")
//        
//        setInitialValuesForProperties()
//        
//        //println("\nPREPARE LAYOUT FINISHED...\n")
//    }
//    
//    override func collectionViewContentSize() -> CGSize {
//        return contentSize()
//    }
//    
//    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
//    
//        println("\nlayoutAttributesForElementsInRect CALLED...")
//        println("Rect: originX \(rect.origin.x), originY \(rect.origin.y)")
//        println("Rect: width \(rect.width), height \(rect.height)")
//        
//        var allElementsAttributes = super.layoutAttributesForElementsInRect(rect) as? [UICollectionViewLayoutAttributes]
//        
//        if allElementsAttributes == nil { return nil }
//        
//        for (index, layoutAttributes) in enumerate(allElementsAttributes!) {
//            switch layoutAttributes.representedElementCategory {
//            case .SupplementaryView:
//                
//                if layoutAttributes.representedElementKind == UICollectionElementKindSectionHeader {
//                    
//                    allElementsAttributes![index] = layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: layoutAttributes.indexPath)
//                }
//            case .Cell:
//                allElementsAttributes![index] = layoutAttributesForItemAtIndexPath(layoutAttributes.indexPath)
//            case .DecorationView: break
//            }
//        }
//        
//        return allElementsAttributes
//    }
//
//    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
//        
//        println("\nlayoutAttributesForItemAtIndexPath CALLED...")
//        println("Indexpath: row \(indexPath.row), section \(indexPath.section)")
//    
//        var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
//        attributes.size = indexPath.row == 0 ? itemSizeLarge : itemSizeSmall
//        attributes.center = centerForCellAtIndexPath[indexPath]!
//        
//        return attributes
//    }
//
//    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
//        
//        //        println("\nlayoutAttributesForSupplementaryViewOfKind CALLED...")
//        //        println("Header indexpath: row \(indexPath.row), section \(indexPath.section)\n")
//        
//        var attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
//        
//        if elementKind == UICollectionElementKindSectionHeader {
//            attributes.size = headerSize
//            attributes.center = centerForHeaderAt(indexPath)!
//        }
//        
//        return attributes
//    }
//    
//    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
//        
//        //println("\nLAYOUT INVALIDATED\n")
//        
//        return false//true
//    }
//    
//    //MARK: Private helper methods
//
//    func centerForCellAt(indexPath: NSIndexPath) -> CGPoint {
//        var center: CGPoint!
//    
//        if isFirstCellAt(indexPath) {
//            center = centerForLargeCell()
//            currentCellOrigin.x += itemSizeLarge.width + marginBetweenCells
//        } else {
//            
//            if cellFitsWithinLine() {
//                if !isRowEvenAt(indexPath) {
//                    center = centerForSmallCell()
//                    currentCellOrigin.y += itemSizeSmall.height + marginBetweenCells
//                } else {
//                    center = centerForSmallCell()
//                    currentCellOrigin.x += itemSizeSmall.width + marginBetweenCells
//                    currentCellOrigin.y -= itemSizeSmall.height + marginBetweenCells
//                }
//            } else {
//                currentCellOrigin.x = margin
//                currentCellOrigin.y += itemSizeLarge.height + marginBetweenDoubleRows
//            
//                center = centerForSmallCell()
//            
//                currentCellOrigin.y += itemSizeSmall.height + marginBetweenCells
//            }
//        }
//        
//        return center
//    }
//    
//    func centerForHeaderAt(indexPath: NSIndexPath) -> CGPoint? {
//        
//        var center: CGPoint?
//        
//        if numberOfItemsInSection[indexPath.section]! == 0 { return nil }
//        
//        switch indexPath.section {
//        case 0: center =  CGPointMake(screenWidth / 2, headerSize.height / 2)
//        case 1: center = CGPointMake(screenWidth / 2, heightOfSection[0]! + headerSize.height / 2)
//        case 2: center = CGPointMake(screenWidth / 2, heightOfSection[0]! + heightOfSection[1]! + headerSize.height / 2)
//        default: break
//        }
//        
//        return center!
//    }
//
//    func contentSize() -> CGSize {
//        
//        var size = CGSizeZero
//        size.width = self.collectionView!.frame.size.width
//        for section in 0..<numberOfSections {
//            size.height += heightOfSection[section]!
//        }
//        
//        size.height += marginBetweenCells
//        
//        //println("Content size: width \(size.width), height \(size.height)")
//        
//        return size
//    }
//
//    func isFirstCellAt(indexPath: NSIndexPath) -> Bool {
//        return indexPath.row == 0 ? true : false
//    }
//
//    func isRowEvenAt(indexPath: NSIndexPath) -> Bool {
//        return indexPath.row % 2 == 0 ? true : false
//    }
//    
//    func centerForLargeCell() -> CGPoint {
//    
//        //println("Large cell origin: (\(currentCellOrigin.x),\(currentCellOrigin.y))")
//    
//        return CGPointMake(currentCellOrigin.x + itemSizeLarge.width / 2, currentCellOrigin.y + itemSizeLarge.height / 2)
//    }
//    
//    func centerForSmallCell() -> CGPoint {
//    
//        //println("Small cell origin: (\(currentCellOrigin.x),\(currentCellOrigin.y))")
//        return CGPointMake(currentCellOrigin.x + itemSizeSmall.width / 2, currentCellOrigin.y + itemSizeSmall.height / 2)
//    }
//    
//    func cellFitsWithinLine() -> Bool {
//        return screenWidth - currentCellOrigin.x > itemSizeSmall.width ? true : false
//    }
//    
//    func isCellLastInSectionAt(indexPath: NSIndexPath) -> Bool {
//        return indexPath.row == numberOfItemsInSection[indexPath.section]! - 1 ? true : false
//    }
//    
//    func setInitialValuesForProperties() {
//    
//        screenWidth = currentScreenWidth()
//        margin = 0
//        
//        //println("Screen width: \(screenWidth), Screen margin: \(margin)")
//        
//        itemSizeSmall = sizeForSmallItem()
//        itemSizeLarge = sizeForLargeItem()
//        
//        //println("Size of small item: width \(itemSizeSmall.width), height: \(itemSizeSmall.height)")
//        //println("Size of large item: width \(itemSizeLarge.width), height: \(itemSizeLarge.height)")
//        
//        marginBetweenDoubleRows = itemSizeSmall.height / 4
//        
//        //println("Margin between double rows: \(marginBetweenDoubleRows)")
//        
//        numberOfSections = self.collectionView!.numberOfSections()
//        calculateNumberOfItemsInSections()
//        numberOfItemsInRow = itemsInRow()
//        
//        //println("Number of items in the row: \(numberOfItemsInRow)")
//        
//        calculateSectionsHeights()
//        calculateCentersForCells()
//    }
//
//    func calculateSectionsHeights() {
//        
//        for section in 0..<numberOfSections {
//            heightOfSection[section] = heightOfSection(section)
//            
//            //println("Section \(section) height: \(heightOfSection[section])")
//        }
//    }
//
//    func heightOfSection(section: Int) -> CGFloat {
//
//        var height: CGFloat!
//    
//        if numberOfItemsInSection[section]! == 0 {return 0.0}
//        
//        //+3 need to consider the first large item
//        
//        let numberOfDoubleRowsInSection = Int((numberOfItemsInSection[section]! + 3) / (2 * numberOfItemsInRow))
//        
//        switch (numberOfItemsInSection[section]! + 3) % (2 * numberOfItemsInRow) {
//        case 0:
//            height = headerSize.height + marginBetweenCells + (itemSizeLarge.height + marginBetweenDoubleRows) * CGFloat(numberOfDoubleRowsInSection) - marginBetweenDoubleRows + marginBetweenCells
//        case 1:
//            height = headerSize.height + marginBetweenCells + (itemSizeLarge.height + marginBetweenDoubleRows) * CGFloat(numberOfDoubleRowsInSection) + itemSizeSmall.height + marginBetweenCells
//        default:
//            height = headerSize.height + marginBetweenCells + (itemSizeLarge.height + marginBetweenDoubleRows) * CGFloat(numberOfDoubleRowsInSection + 1) - marginBetweenDoubleRows + marginBetweenCells
//        }
//        
//        return height
//    }
//    
//    func initialCellOrigin() -> CGPoint {
//        return CGPointMake(margin, headerSize.height + marginBetweenCells)
//    }
//    
//    func itemsInRow() -> Int {
//        return Int((screenWidth - 2 * margin) / itemSizeSmall.width)
//    }
//
//    func calculateNumberOfItemsInSections() {
//        
//        for section in 0..<numberOfSections {
//            numberOfItemsInSection[section] = self.collectionView!.numberOfItemsInSection(section)
//            
//            //println("Number of items in section \(section): \(numberOfItemsInSection[section])")
//        }
//    }
//    
//    func currentScreenWidth() -> CGFloat {
//        return self.collectionView!.frame.size.width
//    }
//    
//    func sizeForSmallItem() -> CGSize {
//        
//        let width = Int((screenWidth - 2 * marginBetweenCells) / 3)
//        
//        return CGSizeMake(CGFloat(width), CGFloat(width) * cellSizeProportion)
//    }
//    
//    func sizeForLargeItem() -> CGSize {
//        
//        let width = 2 * itemSizeSmall.width + marginBetweenCells
//        let height = 2 * itemSizeSmall.height + marginBetweenCells
//        
//        return CGSizeMake(width, height)
//    }
//    
//    func calculateCentersForCells() {
//        
//        /*var*/ currentCellOrigin = initialCellOrigin()
//    
//        for section in 0..<numberOfSections {
//            for item in 0..<numberOfItemsInSection[section]! {
//                let indexPath = NSIndexPath(forItem: item, inSection: section)
//                centerForCellAtIndexPath[indexPath] = centerForCellAt(indexPath)
//            
//                //println("Item center at indexPath(\(indexPath.row),\(indexPath.section)) = (\(centerForCellAtIndexPath[indexPath]!.x),\(centerForCellAtIndexPath[indexPath]!.y)) ")
//                
//                if isCellLastInSectionAt(indexPath) {
//                    currentCellOrigin.x = margin
//                    
//                    switch indexPath.section {
//                    case 0: currentCellOrigin.y = heightOfSection[indexPath.section]! + headerSize.height + marginBetweenCells
//                    case 1:
//                        currentCellOrigin.y = heightOfSection[indexPath.section - 1]! + heightOfSection[indexPath.section]! + headerSize.height + marginBetweenCells
//                    default: break
//                    }
//                }
//            }
//        }
//    }
}
