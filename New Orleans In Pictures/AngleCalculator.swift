//
//  AngleCalculator.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 29.06.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import CoreLocation
import CityKit

class AngleCalculator {
    
    var locationTracker: LocationTracker!
    
    var city: City {
        return City.fetchCity() != nil ? City.fetchCity()! : City.createCityWithName("New Orleans")
    }
    
    var angles: [String : Double] {
        var returnAngles = [String : Double]()
        for pointOfInterest in city.pointsInCity() {
            returnAngles[pointOfInterest.name] = angleToLocation(pointOfInterest.locationOnMap())
        }
        return returnAngles
    }
    
    init(locationTracker: LocationTracker) {
        self.locationTracker = locationTracker
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
}
