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
    
    class var sharedLocationTracker: LocationTracker {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: LocationTracker? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LocationTracker()
        }
        return Static.instance!
    }
    
    
    var currentLocation: CLLocation?
    var currentHeading: CLHeading?
    var delegate: LocationTrackerDelegate?
    
    // MARK: private
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10.0
        locationManager.headingFilter = 1
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations[locations.count - 1]
        
        if currentLocationDiffersFrom(newLocation) {
            currentLocation = newLocation
            
            print("\nLocation manager updated:")
            print("New latitude: \(currentLocation?.coordinate.latitude)")
            print("New longitude: \(currentLocation?.coordinate.longitude)\n")
            
            delegate?.locationUpdated(self)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        currentHeading = newHeading
        delegate?.headingUpdated(self)
    }
}



