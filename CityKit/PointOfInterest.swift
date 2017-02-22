//
//  PointOfInterest.swift
//  New Orleans In Pictures
//
//  Created by Aleksander Shcherbakov on 6/10/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import Foundation
import CoreData

@objc(PointOfInterest)

open class PointOfInterest: NSManagedObject {
    
    @NSManaged open var name: String
    @NSManaged open var planned: NSNumber
    @NSManaged open var seen: NSNumber
    @NSManaged open var city: City
    @NSManaged open var coordinates: Coordinates
    
}





