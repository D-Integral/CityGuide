//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 29.06.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import CoreLocation

class DistanceFormatter {
    class func formatted(var distance: CLLocationDistance) -> String {
        var string: String!
        
        if distance > 999.0 {
            distance = distance / 1000
            if distance < 99.9 {
                string = String(format: "%.1f", distance) + " km"
            }
        } else {
            string = "\(Int(distance)) m"
        }
        
        return string
    }
}

