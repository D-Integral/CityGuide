//
//  PointOfInterest.swift
//  New Orleans In Pictures
//
//  Created by Aleksander Shcherbakov on 6/9/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import Foundation
import CoreData

public class PointOfInterest: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var planned: NSNumber
    @NSManaged public var seen: NSNumber
    @NSManaged public var city: City
    @NSManaged public var coordinates: Coordinates

}
