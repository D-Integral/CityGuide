//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 29.06.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import CoreLocation

class DistanceFormatter {
    class func formatted(_ distance: CLLocationDistance) -> String {
        return distance > 999.0 ? formattedInKilometers(distance) : formattedInMeters(distance)
    }
    
    fileprivate class func formattedInKilometers(_ distance: CLLocationDistance) -> String {
        return String(format: "%.1f", distance / 1000) + " km"
    }
    
    fileprivate class func formattedInMeters(_ distance: CLLocationDistance) -> String {
        return "\(Int(distance)) m"
    }
}

