//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//
import MapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


extension GalleryVC {
    func locationUpdated(_ tracker: LocationTracker) {
        locationTracker = tracker
        
        if formerUserLocation == nil {
            formerUserLocation = locationTracker.currentLocation!
            loadNewRoutes()
        } else {
            if locationTracker.currentLocation?.distance(from: formerUserLocation!) > 200.0 {
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
    
    func headingUpdated(_ tracker: LocationTracker) {
        locationTracker = tracker
    }
}

extension DetailViewController {
    
    func locationUpdated(_ tracker: LocationTracker) {
        locationTracker = tracker
        
        if routeReceiver.routes[self.pointOfInterest.name] == nil {
            routeReceiver.userLocation = locationTracker.currentLocation
            routeReceiver.requestRouteTo(self.pointOfInterest)
        }
        
        if formerUserLocation == nil {
            formerUserLocation = locationTracker.currentLocation
        } else {
            if tracker.currentLocation?.distance(from: formerUserLocation!) > 200.0 {
                routeReceiver.userLocation = locationTracker.currentLocation
                routeReceiver.requestRouteTo(self.pointOfInterest)
            }
        }
        
        locationDataVC.adjustLocationDataView(&locationDataView!, forPointOfInterest: self.pointOfInterest, withLocationTracker: locationTracker)
    }
    
    func headingUpdated(_ tracker: LocationTracker) {
        locationTracker = tracker
        
        locationDataVC.adjustLocationDataView(&locationDataView!, forPointOfInterest: self.pointOfInterest, withLocationTracker: locationTracker)
    }
}


