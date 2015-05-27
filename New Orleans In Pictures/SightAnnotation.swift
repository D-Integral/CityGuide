//
//  SightAnnotation.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 27.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import MapKit

class SightAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var image = UIImage()
    
    init(coordinate: CLLocationCoordinate2D, image: UIImage) {
        self.coordinate = coordinate
        self.image = image
    }   
}
