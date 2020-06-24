//
//  HeaderSetup.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//



import UIKit

extension GalleryVC {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        var header: HeaderView!
        
        if UICollectionView.elementKindSectionHeader == kind
        {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? HeaderView
            header.headerLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            header.backgroundColor = .clear
            header.headerLabel.text = headerTexts[indexPath.section]//.lastPathComponent
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        switch section {
        case 0: return (wantToSee.count == 0) ? CGSize.zero : Constants.headerSize
        case 1: return (unchecked.count == 0) ? CGSize.zero : Constants.headerSize
        case 2: return (alreadySeen.count == 0) ? CGSize.zero : Constants.headerSize
        default: return CGSize.zero
        }
    }
}
