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
    
    func adjustLocationDataView(_ locationDataView: inout ViewForLocationData, forPointOfInterest pointOfInterest: PointOfInterest, withLocationTracker locationTracker: LocationTracker) {
        
        setupBackgroundFor(locationDataView)
        
        if let distance = routesReceiver.routes[pointOfInterest.name]?.distance {
            locationDataView.singleCompassImageView.isHidden = true
            locationDataView.distanceLabel.isHidden = false
            locationDataView.compassImageView.isHidden = false
            
            locationDataView.distanceLabel.text = DistanceFormatter.formatted(distance)
            rotateCompassImageView(locationDataView.compassImageView, toPointOfInterest: pointOfInterest, withLocationTracker: locationTracker)
        } else {
            locationDataView.singleCompassImageView.isHidden = false
            rotateCompassImageView(locationDataView.singleCompassImageView, toPointOfInterest: pointOfInterest, withLocationTracker: locationTracker)
            locationDataView.distanceLabel.isHidden = true
            locationDataView.compassImageView.isHidden = true
        }
    }
    
    //MARK: Private helper methods
    
    func setupBackgroundFor(_ locationDataView: ViewForLocationData) {
        locationDataView.view.backgroundColor = .clear
        locationDataView.backgroundColor = .clear
    }
    
    func rotateCompassImageView(_ imageView: UIImageView, toPointOfInterest pointOfInterest: PointOfInterest, withLocationTracker locationTracker: LocationTracker) {
        
        angleCalculator.locationTracker = locationTracker
        let compassAngle = angleCalculator.angleToLocation(pointOfInterest)
        UIView.animate(withDuration: 0.3, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: -CGFloat(compassAngle))
            }, completion: nil)
    }
}
