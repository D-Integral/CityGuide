//
//  CoordinatesManage.swift
//  New Orleans In Pictures
//
//  Created by Aleksander Shcherbakov on 6/9/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension Coordinates {
    
    public class func coordinatesForPoint(point: PointOfInterest, stringCoordinates: [String]) -> Coordinates {
        let entityDescription = NSEntityDescription.entityForName("Coordinates", inManagedObjectContext: point.managedObjectContext!)
        let coordinates = Coordinates(entity: entityDescription!, insertIntoManagedObjectContext: point.managedObjectContext!)
        
        coordinates.pointOfInterest = point
        coordinates.latitude = NSNumber(double: (stringCoordinates[0] as NSString).doubleValue)
        coordinates.longitude = NSNumber(double: (stringCoordinates[0] as NSString).doubleValue)
        CoreDataStack.sharedInstance.saveContext()

        return coordinates
    }
    
    public func locationOnMap() -> CLLocation {
        let latitude = CLLocationDegrees(self.latitude.doubleValue)
        let longitude = CLLocationDegrees(self.longitude.doubleValue)
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
}