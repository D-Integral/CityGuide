//
//  SightAnnotation.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 27.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import MapKit

class SightAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }   
}
