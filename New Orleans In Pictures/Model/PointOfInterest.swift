//
//  PointOfInterest.swift
//  New Orleans In Pictures
//
//  Created by Skorokhod, Dmytro on 4/27/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import Foundation
import CoreData

class PointOfInterest: NSManagedObject {

    @NSManaged var seen: NSNumber
    @NSManaged var planned: NSNumber
    @NSManaged var coordinate: NSNumber
    @NSManaged var name: String

}
