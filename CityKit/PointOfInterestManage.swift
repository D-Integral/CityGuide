//
//  PointOfInterestManage.swift
//  New Orleans In Pictures
//
//  Created by Aleksander Shcherbakov on 6/9/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension PointOfInterest {
    
    public class func newPointInCity(city: City) -> PointOfInterest {
        
        let entityDescription = NSEntityDescription.entityForName("PointOfInterest", inManagedObjectContext: city.managedObjectContext!)
        let pointOfInterest = PointOfInterest(entity: entityDescription!, insertIntoManagedObjectContext: city.managedObjectContext!)
        pointOfInterest.city = city
        
        CoreDataStack.sharedInstance.saveContext()
        return pointOfInterest
    }
    
    public func image() -> UIImage {
        return UIImage(named: name)!
    }
    
    // Convenience method
    public func locationOnMap() -> CLLocation {
        return coordinates.locationOnMap()
    }
}