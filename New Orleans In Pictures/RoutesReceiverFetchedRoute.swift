//
//  RoutesReceiverFetchedRoute.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 19.08.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//
import MapKit
import CityKit

extension TableViewController {
    func routeReceived(route: MKRoute, forPointOfInterest pointOfInterest: PointOfInterest) {
        
        println("From TableVC RouteDelegate.\nRoute received for \(pointOfInterest.name): \(route.distance)")
        
        routeReceiver.routes.updateValue(route, forKey: self.pointOfInterest.name)
        showRoute()
        locationDataVC.adjustLocationDataView(&locationDataView!, forPointOfInterest: self.pointOfInterest, withLocationTracker: locationTracker)
    }
}
