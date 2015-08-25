//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//
import MapKit

extension GalleryVC {
    func locationUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        
        loadRoutes()
    }
    
    func loadRoutes() {
        locationDataVC.routesReceiver.removeAllRoutes()
        collectionView?.reloadData()
        locationDataVC.routesReceiver.userLocation = locationTracker.currentLocation
        locationDataVC.routesReceiver.city = city
        locationDataVC.routesReceiver.requestRoutesToPointsOfInterest()
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        
        //collectionView?.reloadData()
    }
}

extension DetailViewController {
    func locationUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        
        routeReceiver.userLocation = locationTracker.currentLocation
        routeReceiver.requestRouteTo(self.pointOfInterest)
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        
        locationDataVC.adjustLocationDataView(&locationDataView!, forPointOfInterest: self.pointOfInterest, withLocationTracker: locationTracker)
    }
}


