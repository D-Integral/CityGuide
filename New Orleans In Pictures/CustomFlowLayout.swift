//
//  CustomFlowLayout.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 22.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewLayout {
    
    struct Constants {
        static let margin: CGFloat = 5.0
        static let sizeLarge = CGSizeMake(150, 195)
        static let sizeSmall = CGSizeMake(Constants.sizeLarge.width / 2, (Constants.sizeLarge.height - Constants.margin) / 2)
    }
    
    var numberOfItemsInSection = [Int : Int]()
    var viewSize: CGSize!
    var leftEdgeForItem: CGFloat!
    var topEdgeForItem: CGFloat!
    
    override func prepareLayout() {
        super.prepareLayout()
        
        for i in 0..<self.collectionView!.numberOfSections()  {
            numberOfItemsInSection[i] = self.collectionView?.numberOfItemsInSection(i)
        }
        
        viewSize = self.collectionView?.frame.size
        
        leftEdgeForItem = self.collectionView?.frame.origin.x
        topEdgeForItem = self.collectionView?.frame.origin.y
    }
    
    override func collectionViewContentSize() -> CGSize {
        return viewSize
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        //MARK: size adjustment
        attributes.size = indexPath.row == 0 ? Constants.sizeLarge : Constants.sizeSmall
        
        //MARK: center adjustment
        if indexPath.row == 0 {
            attributes.center = centerForLargeItemAt(indexPath)
            moveLeftEdgeForItemWithPoints(Constants.sizeLarge.width + Constants.margin)
        } else {
            if !isEven(indexPath.row) {
                attributes.center = centerForNotEvenSmallItemAt(indexPath)
                moveTopEdgeForItemWithPoints(Constants.sizeSmall.height + Constants.margin)
            } else {
                attributes.center = centerforEvenSmallItemAt(indexPath)
                moveTopEdgeForItemWithPoints(-(Constants.sizeSmall.height + Constants.margin))
                moveLeftEdgeForItemWithPoints(Constants.sizeSmall.width + Constants.margin)
            }
        }
        
        return attributes
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func centerForLargeItemAt(indexPath: NSIndexPath) -> CGPoint {
        return CGPointMake(Constants.sizeLarge.width / 2 + Constants.margin, Constants.sizeLarge.height / 2 + Constants.margin)
    }
    
    func centerForSmallItemAt(indexPath: NSIndexPath) -> CGPoint {
        return !isEven(indexPath.row) ? centerForNotEvenSmallItemAt(indexPath) : centerforEvenSmallItemAt(indexPath)
    }
    
    func centerForNotEvenSmallItemAt(indexPath: NSIndexPath) -> CGPoint {
        return CGPointMake(leftEdgeForItem + Constants.sizeSmall.width / 2, topEdgeForItem + Constants.sizeSmall.height / 2)
    }
    
    func centerforEvenSmallItemAt(indexPath: NSIndexPath) -> CGPoint {
        return CGPointMake(leftEdgeForItem + Constants.sizeSmall.width / 2, topEdgeForItem + Constants.sizeSmall.height / 2)
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
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var attributes = [AnyObject]()
        
        for i in 0..<self.collectionView!.numberOfSections() {
            for j in 0..<self.numberOfItemsInSection[i]! {
                let indexPath = NSIndexPath(forItem: j, inSection: i)
                attributes.append(self.layoutAttributesForItemAtIndexPath(indexPath))
            }
        }
        
        return attributes
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
