//
//  City.swift
//  New Orleans In Pictures
//
//  Created by Aleksander Shcherbakov on 6/9/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import Foundation
import CoreData

public class City: NSManagedObject {

    @NSManaged public var name: String
    @NSManaged public var allSights: NSSet

}
