//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

extension GalleryVC {
    func locationUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        
        reloadRoutesToPointsOfInterest()
        reloadCompassAngles()
        collectionView?.reloadData()
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        
        reloadCompassAngles()
        collectionView?.reloadData()
    }
}

extension TableViewController {
    func locationUpdated(tracker: LocationTracker) {
        locationTracker = tracker
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
    }
}


