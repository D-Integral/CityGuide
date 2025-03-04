//
//  SightAnnotationView.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 27.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import MapKit

class SightAnnotationView: MKAnnotationView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
}
