//
//  AngleCalculator.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 29.06.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import Foundation
import CoreLocation

class AngleCalculator: LocationTrackerDelegate {
    
    var locationTracker: LocationTracker = LocationTracker()
    var angles: NSDictionary = [String : Double]()
    
    init(locationTracker: LocationTracker) {
        self.locationTracker = locationTracker
        setup()
    }
    
    func setup() {
        self.locationTracker.delegate = self
        self.locationTracker.startUpdating()
    }
    
    func angleToLocation(pointOfInterestLocation: CLLocation) -> Double {
        var angle: Double = 0.0
        
        if let userLocation = locationTracker.currentLocation {
            
            let x1 = userLocation.coordinate.longitude
            let y1 = userLocation.coordinate.latitude
            
            let x2 = pointOfInterestLocation.coordinate.longitude
            let y2 = pointOfInterestLocation.coordinate.latitude
            
            let a = abs(x1 - x2)
            let b = abs(y1-y2)
            let c = sqrt(a*a + b*b)
            
            if x1 > x2 && y1 < y2 {
                angle = acos((b*b + c*c - a*a) / (2*b*c))
            }
            
            if x1 > x2 && y1 > y2 {
                angle = M_PI - acos((b*b + c*c - a*a) / (2*b*c))
            }
            
            if x1 < x2 && y1 > y2 {
                angle = M_PI + acos((b*b + c*c - a*a) / (2*b*c))
            }
            
            if x1 < x2 && y1 < y2 {
                angle = 2 * M_PI - acos((b*b + c*c - a*a) / (2*b*c))
            }
        }
        
        if let heading = locationTracker.currentHeading {
            var degrees = heading.magneticHeading
            var radians = (degrees * M_PI / 180)
            angle = angle + radians // + or - needs to be tested on the device
        }
        
        return angle
    }
    
    func locationUpdated(tracker: LocationTracker) {
        locationTracker = tracker
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
    }

}
