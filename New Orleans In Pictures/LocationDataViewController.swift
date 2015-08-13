//
//  LocationDataViewController.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 08.08.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import CityKit
import MapKit

class LocationDataViewController: NSObject, RoutesReceiverFetchedRouteDelegate {
    
    var locationTracker: LocationTracker!
    var angleCalculator = AngleCalculator()
    var routesReceiver = RoutesReceiver.sharedRoutesReceiver
    
    var routesToPointsOfInterest: [String : MKRoute]!
    
    override init() {
        super.init()
        routesReceiver.delegateForRoute = self
        routesToPointsOfInterest = [String : MKRoute]()
    }
    
    func adjustLocationDataView(inout locationDataView: ViewForLocationData, forPointOfInterest pointOfInterest: PointOfInterest, withLocationTracker locationTracker: LocationTracker) {
        
        setupBackgroundFor(locationDataView)
        
        if let distance = routesReceiver.routes[pointOfInterest.name]?.distance {//routesToPointsOfInterest[pointOfInterest.name]?.distance {
            locationDataView.distanceLabel.text = DistanceFormatter.formatted(distance)
        }
        
        setupCompassImageViewFor(locationDataView, toPointOfInterest: pointOfInterest, withLocationTracker: locationTracker)
    }
    
    //MARK: Private helper methods
    
    func setupBackgroundFor(locationDataView: ViewForLocationData) {
        locationDataView.view.backgroundColor = .clearColor()
        locationDataView.backgroundColor = .clearColor()
    }
    
    func setupCompassImageViewFor(locationDataView: ViewForLocationData, toPointOfInterest pointOfInterest: PointOfInterest, withLocationTracker locationTracker: LocationTracker) {
        
        angleCalculator.locationTracker = locationTracker
        let compassAngle = angleCalculator.angleToLocation(pointOfInterest)
        UIView.animateWithDuration(1, animations: {
            locationDataView.compassImageView.transform = CGAffineTransformMakeRotation(-CGFloat(compassAngle))
            }, completion: nil)
    }
    
    func removeAllSavedRoutes() {
        routesToPointsOfInterest = [String : MKRoute]()
    }
    
    //MARK: RoutesReceiverDelegate
    
    func routeReceived(route: MKRoute, forPointOfIneterest pointOfInterest: PointOfInterest) {
        println("LocationDataViewController: received route \(route.distance) for \(pointOfInterest.name)")
        routesToPointsOfInterest[pointOfInterest.name] = route
        println("\(route.distance) saved: \(routesToPointsOfInterest[pointOfInterest.name]?.distance)\n")
    }
}
