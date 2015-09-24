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
        
        if formerUserLocation == nil {
            formerUserLocation = locationTracker.currentLocation!
            loadNewRoutes()
        } else {
            if locationTracker.currentLocation?.distanceFromLocation(formerUserLocation!) > 200.0 {
                formerUserLocation = locationTracker.currentLocation!
                loadNewRoutes()
            }
        }
    }
    
    func loadNewRoutes() {
        collectionView?.reloadData()
        locationDataVC.routesReceiver.userLocation = locationTracker.currentLocation
        locationDataVC.routesReceiver.city = city
        locationDataVC.routesReceiver.requestRoutesToPointsOfInterest()
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
    }
}

extension DetailViewController {
    
    func locationUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        
        if routeReceiver.routes[self.pointOfInterest.name] == nil {
            routeReceiver.userLocation = locationTracker.currentLocation
            routeReceiver.requestRouteTo(self.pointOfInterest)
        }
        
        if formerUserLocation == nil {
            formerUserLocation = locationTracker.currentLocation
        } else {
            if tracker.currentLocation?.distanceFromLocation(formerUserLocation!) > 200.0 {
                routeReceiver.userLocation = locationTracker.currentLocation
                routeReceiver.requestRouteTo(self.pointOfInterest)
            }
        }
        
        locationDataVC.adjustLocationDataView(&locationDataView!, forPointOfInterest: self.pointOfInterest, withLocationTracker: locationTracker)
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        
        locationDataVC.adjustLocationDataView(&locationDataView!, forPointOfInterest: self.pointOfInterest, withLocationTracker: locationTracker)
    }
}


