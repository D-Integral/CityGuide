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
        collectionView?.reloadData()
        
        loadRoutes()
    }
    
    func loadRoutes() {
        locationDataVC.routesReceiver.removeAllRoutes()
        locationDataVC.routesReceiver.userLocation = locationTracker.currentLocation
        locationDataVC.routesReceiver.city = city
        locationDataVC.routesReceiver.requestRoutesToPointsOfInterest()
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        
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


