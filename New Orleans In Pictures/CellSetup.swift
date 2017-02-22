//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import CityKit

extension GalleryVC {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! PictureCell
        
        switch indexPath.section {
        case 0: setupCell(&cell, forPoint: wantToSee[indexPath.row])
        case 1: setupCell(&cell, forPoint: unchecked[indexPath.row])
        case 2: setupCell(&cell, forPoint: alreadySeen[indexPath.row])
        default: break
        }
        
        return cell
    }

    func setupCell(_ cell: inout PictureCell, forPoint point: PointOfInterest) {
        cell.imageView.image = point.image()
        cell.nameLabel.text = NSLocalizedString(point.name, comment: point.name)
    
        locationDataVC.adjustLocationDataView(&cell.locationDataView!, forPointOfInterest: point, withLocationTracker: locationTracker)
    }
}

