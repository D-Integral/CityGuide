//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 29.06.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import CoreLocation

class DistanceFormatter {
    class func formatted(distance: CLLocationDistance) -> String {
        return distance > 999.0 ? formattedInKilometers(distance) : formattedInMeters(distance)
    }
    
    private class func formattedInKilometers(distance: CLLocationDistance) -> String {
        return distance < 99999 ? (String(format: "%.1f", distance / 1000) + " km") : "More 100 km"
    }
    
    private class func formattedInMeters(distance: CLLocationDistance) -> String {
        return "\(Int(distance)) m"
    }
}

