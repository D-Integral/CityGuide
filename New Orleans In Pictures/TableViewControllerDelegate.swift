//
//  TableViewControllerDelegate.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 21.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

extension GalleryVC {
    func pointOfInterestStateDidChange() {
        //println("Notification from TableVC arrived.")
        
        retrievePointsOfInterest()
        sortItemsByRouteDistances()
        collectionView?.reloadData()
    }
}
