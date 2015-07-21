//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

extension GalleryVC {
    func locationUpdated(tracker: LocationTracker) {
        println("\nLocationTracker updated:")
        println("New latitude: \(tracker.currentLocation?.coordinate.latitude)")
        println("New longitude: \(tracker.currentLocation?.coordinate.longitude)\n")
        
        
        locationTracker = tracker
        
        angleCalculator.locationTracker = locationTracker
        compassAngles = angleCalculator.angles
        collectionView?.reloadData()
        
        routesReceiver.removeAllRoutes()
        routesReceiver.userLocation = locationTracker.currentLocation
        routesReceiver.city = city
        routesReceiver.requestRoutesToPointsOfInterest()
        
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        
        angleCalculator.locationTracker = locationTracker
        compassAngles = angleCalculator.angles
        
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


