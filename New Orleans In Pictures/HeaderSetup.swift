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
            
            switch indexPath.section {
            case 0: setupHeader(&header!, inSection: indexPath.section)
            case 1: setupHeader(&header!, inSection: indexPath.section)
            case 2: setupHeader(&header!, inSection: indexPath.section)
            default: break
            }
        }
        
        return header
    }
    
    func setupHeader(inout header: HeaderView, inSection section: Int) {
        header.headerLabel.font = UIFont.boldSystemFontOfSize(20.0)
        header.headerLabel.text = headerTexts[section]
        header.backgroundColor = UIColor(patternImage: UIImage(named: "Texture_New_Orleans_2.png")!)
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
