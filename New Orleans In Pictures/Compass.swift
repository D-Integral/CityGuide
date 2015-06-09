//
//  Compass.swift
//  Compass
//
//  Created by Александр Нужный on 14.04.15.
//  Copyright (c) 2015 Александр Нужный. All rights reserved.
//

import UIKit
import CoreLocation

class Compass: NSObject, CLLocationManagerDelegate {
    var compassImage: UIImageView?
    var locationManager: CLLocationManager?
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.headingFilter = 1
        locationManager?.delegate = self
        locationManager?.startUpdatingHeading()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        var degrees = newHeading.magneticHeading
        var radians = (degrees * M_PI / 180)
        self.compassImage?.transform = CGAffineTransformMakeRotation(CGFloat(-radians))
    }
}
