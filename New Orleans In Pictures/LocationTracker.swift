//
//  LocationTracker.swift
//  Watch The World
//
//  Authors: Dmytro Skorokhod, Alexander Nuzhniy. 2015
//  Copyright (c) 2015 D Integralas (Lithuania, EU). All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationTrackerDelegate {
    func locationUpdated(tracker: LocationTracker)
    func headingUpdated(tracker: LocationTracker)
}

class LocationTracker: NSObject, CLLocationManagerDelegate {
    
    // MARK: public
    
    var currentLocation: CLLocation?
    var currentHeading: CLHeading?
    var delegate: LocationTrackerDelegate?
    
    func distanceToLocation(aLocation : CLLocation) -> CLLocationDistance {
        return aLocation.distanceFromLocation(currentLocation!)
    }
    
    // MARK: private
    
    var locationManager : CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.headingFilter = 15
        locationManager.delegate = self
        startUpdating()
    }
    
    func startUpdating() {
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        currentLocation = locations[locations.count - 1] as? CLLocation
        delegate?.locationUpdated(self)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        currentHeading = newHeading
        delegate?.headingUpdated(self)
    }
    
    func angleToLocation(sightLocation: CLLocation) -> Double {
        var angle: Double = 0.0
        
        if let userLocation = currentLocation {
            
            let x1 = userLocation.coordinate.longitude
            let y1 = userLocation.coordinate.latitude
            
            let x2 = sightLocation.coordinate.longitude
            let y2 = sightLocation.coordinate.latitude
            
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
        
        if let heading = currentHeading {
            var degrees = heading.magneticHeading
            var radians = (degrees * M_PI / 180)
            angle = angle + radians // + or - needs to be tested on the device
        }
        
        return angle
    }
}


