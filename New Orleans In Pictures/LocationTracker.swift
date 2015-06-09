//
//  LocationTracker.swift
//  Watch The World
//
//  Authors: Dmytro Skorokhod, Alex Nuzhny. 2015
//  Copyright (c) 2015 D Integralas (Lithuania, EU). All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationTrackerDelegate {
    func locationUpdated(tracker: LocationTracker)
}

class LocationTracker: NSObject, CLLocationManagerDelegate {
    
    // MARK: public
    
    var currentLocation: CLLocation?
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
    
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 20.0
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        currentLocation = locations[locations.count - 1] as? CLLocation
        delegate?.locationUpdated(self)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
    }
}

