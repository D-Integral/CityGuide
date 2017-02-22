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
    
    public class func newPointInCity(_ city: City) -> PointOfInterest {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "PointOfInterest", in: city.managedObjectContext!)
        let pointOfInterest = PointOfInterest(entity: entityDescription!, insertInto: city.managedObjectContext!)
        pointOfInterest.city = city
        
        CoreDataStack.sharedInstance.saveContext()
        return pointOfInterest
    }
    
    public func isPlanned() -> Bool {
        return planned.boolValue
    }
    
    public func isSeen() -> Bool {
        return seen.boolValue
    }
    
    public func image() -> UIImage {
        return UIImage(named: name)!
    }
    
    // Convenience method
    public func locationOnMap() -> CLLocation {
        return coordinates.locationOnMap()
    }

}
