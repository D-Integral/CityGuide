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
        
        if routesToPointsOfInterest[point.name] != nil {
            cell.distanceLabel.text = DistanceFormatter.formatted(routesToPointsOfInterest[point.name]!.distance)
        } else {
            cell.distanceLabel.text = "Requesting..."
        }
        
        rotateCompassView(cell.compassImage, forPointOfInterest: point)
    }
    
    func rotateCompassView(imageView: UIImageView, forPointOfInterest point: PointOfInterest) {
        imageView.image = UIImage(named: "arrow_up.png")
        UIView.animateWithDuration(1, animations: {
            imageView.transform = CGAffineTransformMakeRotation(-CGFloat(self.compassAngles[point.name]!))
            }, completion: nil)
    }
}

