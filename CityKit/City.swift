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

open class City: NSManagedObject {
    
    @NSManaged open var name: String
    @NSManaged open var pointsOfInterest: NSSet
}


