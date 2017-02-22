//
//  Coordinates.swift
//  New Orleans In Pictures
//
//  Created by Aleksander Shcherbakov on 6/10/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import Foundation
import CoreData

@objc(Coordinates)

open class Coordinates: NSManagedObject {
    
    @NSManaged open var longitude: NSNumber
    @NSManaged open var latitude: NSNumber
    @NSManaged open var pointOfInterest: PointOfInterest
    
}
