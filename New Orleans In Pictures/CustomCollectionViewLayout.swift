//
//  CustomCollectionViewLayout.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 27.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
    
class CustomFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    struct Constants {
        static let margin: CGFloat = 5.0
        static let itemSizeLarge = CGSizeMake(150, 195)
        static let itemSizeSmall = CGSizeMake(Constants.itemSizeLarge.width / 2, (Constants.itemSizeLarge.height - Constants.margin) / 2)
        static let headerSize = CGSizeMake(50.0, 50.0)
    }
    
    var numberOfItemsInSection = [Int : Int]()
    var viewSize: CGSize!
    var leftEdgeForItem: CGFloat!
    var topEdgeForItem: CGFloat!
    var numberOfDoubleRow: Int = 0
    
    override func prepareLayout() {
        super.prepareLayout()
        setInitialValues()
    }
    
    override func collectionViewContentSize() -> CGSize {
        return viewSize
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
        
        //MARK: size adjustment
        attributes.size = indexPath.row == 0 ? Constants.itemSizeLarge : Constants.itemSizeSmall
        
        //MARK: center adjustment
        if isFirstItemInSectionAt(indexPath) {
            attributes.center = centerForLargeItemAt(indexPath)
            moveLeftEdgeForItemWithPoints(Constants.itemSizeLarge.width + 2 * Constants.margin)
        } else {
            if itemFitsWithinLine() {
                if !isEven(indexPath.row) {
                    attributes.center = centerForNotEvenSmallItemAt(indexPath)
                    moveTopEdgeForItemWithPoints(Constants.itemSizeSmall.height + Constants.margin)
                } else {
                    attributes.center = centerforEvenSmallItemAt(indexPath)
                    moveTopEdgeForItemWithPoints(-(Constants.itemSizeSmall.height + Constants.margin))
                    moveLeftEdgeForItemWithPoints(Constants.itemSizeSmall.width + Constants.margin)
                }
            } else {
                moveToNextDoubleRow()
                attributes.center = centerForNotEvenSmallItemAt(indexPath)
                moveTopEdgeForItemWithPoints(Constants.itemSizeSmall.height + Constants.margin)
            }
        }
        
        return attributes
    }
    
        override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
    
            var attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
    
            if elementKind == UICollectionElementKindSectionHeader {
                attributes.size = CGSizeMake(300, 100)
                attributes.center = CGPointMake(viewSize.width / 2, viewSize.height / 2)
                attributes.zIndex = 1
            }
    
            return attributes
        }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Private helper methods
    
    func setInitialValues() {
        for i in 0..<self.collectionView!.numberOfSections()  {
            numberOfItemsInSection[i] = self.collectionView?.numberOfItemsInSection(i)
        }
        //needs to be reviewed
        viewSize = CGSizeMake(self.collectionView!.frame.size.width, self.collectionView!.frame.size.height * 2)
        setDefaultEdgesForItem()
        numberOfDoubleRow = 0
    }
    
    func isSectionEmpty(section: Int) -> Bool {
        return numberOfItemsInSection[section] == 0 ? true : false
    }
    
    func isFirstItemInSectionAt(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == 0 ? true : false
    }
    
    func setDefaultEdgesForItem() {
        leftEdgeForItem = self.collectionView?.frame.origin.x
        topEdgeForItem = self.collectionView?.frame.origin.y
    }
    
    func moveToNextDoubleRow() {
        numberOfDoubleRow++
        setDefaultEdgesForItem()
        moveTopEdgeForItemWithPoints((Constants.itemSizeLarge.height + 5 * Constants.margin) * CGFloat(numberOfDoubleRow))
    }
    
    func itemFitsWithinLine() -> Bool {
        return (viewSize.width - leftEdgeForItem > Constants.itemSizeSmall.width + Constants.margin) ? true : false
    }
    
    func centerForLargeItemAt(indexPath: NSIndexPath) -> CGPoint {
        return CGPointMake(Constants.itemSizeLarge.width / 2 + Constants.margin, Constants.itemSizeLarge.height / 2 + Constants.margin)
    }
    
    func centerForSmallItemAt(indexPath: NSIndexPath) -> CGPoint {
        return !isEven(indexPath.row) ? centerForNotEvenSmallItemAt(indexPath) : centerforEvenSmallItemAt(indexPath)
    }
    
    func centerForNotEvenSmallItemAt(indexPath: NSIndexPath) -> CGPoint {
        return CGPointMake(leftEdgeForItem + Constants.itemSizeSmall.width / 2, topEdgeForItem + Constants.itemSizeSmall.height / 2)
    }
    
    func centerforEvenSmallItemAt(indexPath: NSIndexPath) -> CGPoint {
        return CGPointMake(leftEdgeForItem + Constants.itemSizeSmall.width / 2, topEdgeForItem + Constants.itemSizeSmall.height / 2)
    }
    
    func moveLeftEdgeForItemWithPoints(points: CGFloat) {
        leftEdgeForItem = leftEdgeForItem + points
    }
    
    func moveTopEdgeForItemWithPoints(points: CGFloat) {
        topEdgeForItem = topEdgeForItem + points
    }
    
    func isEven(number: Int) -> Bool {
        return number % 2 == 0 ? true : false
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
