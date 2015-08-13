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
    
    var routesToPointsOfInterest = [PointOfInterest : MKRoute]()
    
    override init() {
        super.init()
        routesReceiver.delegateForRoute = self
    }
    
    func adjustLocationDataView(inout locationDataView: ViewForLocationData, forPointOfInterest pointOfInterest: PointOfInterest, withLocationTracker locationTracker: LocationTracker) {
        
        setupBackgroundFor(locationDataView)
        
        if let distance = routesToPointsOfInterest[pointOfInterest]?.distance {
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
    
    //MARK: RoutesReceiverDelegate
    
    func routeReceived(route: MKRoute, forPointOfIneterest pointOfInterest: PointOfInterest) {
        routesToPointsOfInterest[pointOfInterest] = route
    }
}
