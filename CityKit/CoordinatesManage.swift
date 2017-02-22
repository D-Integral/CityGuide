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
    
    public class func coordinatesForPoint(_ point: PointOfInterest, coordinate: CLLocationCoordinate2D) -> Coordinates {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Coordinates", in: point.managedObjectContext!)
        let coordinates = Coordinates(entity: entityDescription!, insertInto: point.managedObjectContext!)
        
        coordinates.pointOfInterest = point
        coordinates.latitude = NSNumber(coordinate.latitude)
        coordinates.longitude = NSNumber(coordinate.longitude)
        CoreDataStack.sharedInstance.saveContext()
        
        return coordinates
    }
    
    public func locationOnMap() -> CLLocation {
        let latitude = CLLocationDegrees(self.latitude.doubleValue)
        let longitude = CLLocationDegrees(self.longitude.doubleValue)
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
