//
//  City.swift
//  New Orleans In Pictures
//
//  Created by Aleksander Shcherbakov on 6/10/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//



import Foundation
import CoreData

@objc(City)

public class City: NSManagedObject {
    
    @NSManaged public var name: String
    @NSManaged public var pointsOfInterest: NSSet
    @NSManaged public var edges: [String : NSNumber]
}


