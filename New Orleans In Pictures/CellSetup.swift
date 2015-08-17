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
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! PictureCell
        
        switch indexPath.section {
        case 0: setupCell(&cell, forPoint: wantToSee[indexPath.row])
        case 1: setupCell(&cell, forPoint: unchecked[indexPath.row])
        case 2: setupCell(&cell, forPoint: alreadySeen[indexPath.row])
        default: break
        }
        
        return cell
    }

    func setupCell(inout cell: PictureCell, forPoint point: PointOfInterest) {
        cell.imageView.image = point.image()
        cell.nameLabel.text = point.name
    
        locationDataVC.adjustLocationDataView(&cell.locationDataView!, forPointOfInterest: point, withLocationTracker: locationTracker)
    }
}

