//
//  HeaderSetup.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//



import UIKit

extension GalleryVC {
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        var header: HeaderView!
        
        if UICollectionElementKindSectionHeader == kind
        {
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath) as? HeaderView
            
            header.headerLabel.font = UIFont.boldSystemFontOfSize(20.0)
            header.backgroundColor = UIColor(patternImage: UIImage(named: "Texture_New_Orleans_2.png")!)
            header.headerLabel.text = headerTexts[indexPath.section]
            
            println("\nHeader in section: \(indexPath.section) assigned test: \(headerTexts[indexPath.section])\n")
        }
        
        return header
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size: CGSize!
        
        switch section {
        case 0: size = (wantToSee.count == 0) ? CGSizeZero : Constants.headerSize
        case 1: size = (unchecked.count == 0) ? CGSizeZero : Constants.headerSize
        case 2: size = (alreadySeen.count == 0) ? CGSizeZero : Constants.headerSize
        default: break
        }
        
        return size
    }
}
