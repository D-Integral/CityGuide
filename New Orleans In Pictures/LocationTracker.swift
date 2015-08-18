//
//  LocationTracker.swift
//  Watch The World
//
//  Authors: Dmytro Skorokhod, Alexander Nuzhniy. 2015
//  Copyright (c) 2015 D Integralas (Lithuania, EU). All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

protocol LocationTrackerDelegate {
    func locationUpdated(tracker: LocationTracker)
    func headingUpdated(tracker: LocationTracker)
}

class LocationTracker: NSObject, CLLocationManagerDelegate {
    
    // MARK: public
    
    var currentLocation: CLLocation?
    var currentHeading: CLHeading?
    var delegate: LocationTrackerDelegate?
    
    func distanceToLocation(aLocation: CLLocation) -> CLLocationDistance {
        return currentLocation != nil ? aLocation.distanceFromLocation(currentLocation!) : CLLocationDistance()
    }
    
    // MARK: private
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.headingFilter = 30
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
    
    func currentLocationDiffersFrom(newLocation: CLLocation) -> Bool {
        return currentLocation?.coordinate.latitude != newLocation.coordinate.latitude || currentLocation?.coordinate.longitude != newLocation.coordinate.longitude ? true : false
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let newLocation = locations[locations.count - 1] as? CLLocation
        
        if currentLocationDiffersFrom(newLocation!) {
            currentLocation = newLocation
        
            println("\nLocation manager updated:")
            println("New latitude: \(currentLocation?.coordinate.latitude)")
            println("New longitude: \(currentLocation?.coordinate.longitude)\n")
        
            delegate?.locationUpdated(self)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        currentHeading = newHeading
        delegate?.headingUpdated(self)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        currentLocation = newLocation
        delegate?.locationUpdated(self)
    }
}


