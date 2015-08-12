//
//  LocationDataViewController.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 08.08.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import CityKit

class LocationDataViewController: UIViewController {
    
    func adjustLocationDataView(inout locationDataView: ViewForLocationData, forPointOfInterest pointOfInterest: PointOfInterest, withLocationTracker locationTracker: LocationTracker) {
        
        locationDataView.view.backgroundColor = .clearColor()
        locationDataView.backgroundColor = .clearColor()
        
        locationDataView.distanceLabel.textColor = .redColor()
        locationDataView.distanceLabel.text = pointOfInterest.name
        
        var angleCalculator = AngleCalculator()
        angleCalculator.locationTracker = locationTracker
        let compassAngle = angleCalculator.angleToLocation(pointOfInterest)
        UIView.animateWithDuration(1, animations: {
            locationDataView.compassImageView.transform = CGAffineTransformMakeRotation(-CGFloat(compassAngle))
            }, completion: nil)
    }
}
