//
//  Coordinates.swift
//  New Orleans In Pictures
//
//  Created by Aleksander Shcherbakov on 6/9/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import Foundation
import CoreData

public class Coordinates: NSManagedObject {

    @NSManaged public var longitude: NSNumber
    @NSManaged public var latitude: NSNumber
    @NSManaged public var pointOfInterest: PointOfInterest

}
