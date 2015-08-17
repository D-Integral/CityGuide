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

class LocationDataViewController: NSObject {
    
    var locationTracker: LocationTracker!
    var angleCalculator = AngleCalculator()
    var routesReceiver = RoutesReceiver.sharedRoutesReceiver
    
    func adjustLocationDataView(inout locationDataView: ViewForLocationData, forPointOfInterest pointOfInterest: PointOfInterest, withLocationTracker locationTracker: LocationTracker) {
        
        setupBackgroundFor(locationDataView)
        if let distance = routesReceiver.routes[pointOfInterest.name]?.distance {
            locationDataView.singleCompassImageView.hidden = true
            locationDataView.distanceLabel.hidden = false
            locationDataView.compassImageView.hidden = false
            locationDataView.distanceLabel.text = DistanceFormatter.formatted(distance)
            rotateCompassImageView(locationDataView.compassImageView, toPointOfInterest: pointOfInterest, withLocationTracker: locationTracker)
        } else {
            locationDataView.singleCompassImageView.hidden = false
            rotateCompassImageView(locationDataView.singleCompassImageView, toPointOfInterest: pointOfInterest, withLocationTracker: locationTracker)
            locationDataView.distanceLabel.hidden = true
            locationDataView.compassImageView.hidden = true
    
        }
        
        
        //setupBackgroundFor(locationDataView)
        
//        var distanceLabel = UILabel(frame: CGRectMake(locationDataView.bounds.origin.x, locationDataView.bounds.origin.y, locationDataView.bounds.width / 2, locationDataView.bounds.height))
//        distanceLabel.backgroundColor = .blackColor()
//        if let distance = routesReceiver.routes[pointOfInterest.name]?.distance {
//            distanceLabel.text = DistanceFormatter.formatted(distance)
//        }
//        locationDataView.addSubview(distanceLabel)
        
        
    }
    
    //MARK: Private helper methods
    
    func setupBackgroundFor(locationDataView: ViewForLocationData) {
        locationDataView.view.backgroundColor = .clearColor()
        locationDataView.backgroundColor = .clearColor()
    }
    
    func rotateCompassImageView(imageView: UIImageView, toPointOfInterest pointOfInterest: PointOfInterest, withLocationTracker locationTracker: LocationTracker) {
        
        angleCalculator.locationTracker = locationTracker
        let compassAngle = angleCalculator.angleToLocation(pointOfInterest)
        UIView.animateWithDuration(1, animations: {
            imageView.transform = CGAffineTransformMakeRotation(-CGFloat(compassAngle))
            }, completion: nil)
    }
}
