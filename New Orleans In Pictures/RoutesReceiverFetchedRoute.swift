//
//  RoutesReceiverFetchedRoute.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 19.08.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//
import MapKit
import CityKit

extension DetailViewController {
    func routeReceived(route: MKRoute, forPointOfInterest pointOfInterest: PointOfInterest) {
        
        if pointOfInterest == self.pointOfInterest {
            showRoute()
            locationDataVC.adjustLocationDataView(&locationDataView!, forPointOfInterest: self.pointOfInterest, withLocationTracker: locationTracker)
        }
    }
}
