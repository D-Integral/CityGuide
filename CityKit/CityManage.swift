//
//  CityManage.swift
//  New Orleans In Pictures
//
//  Created by Aleksander Shcherbakov on 6/9/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//


import Foundation
import CoreData


extension City {
    
    public class func fetchCity() -> City? {
        let cityFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let context = CoreDataStack.sharedInstance.managedObjectContext
        
        var city: City?
        
        let results = try! context?.fetch(cityFetch) as! [City]
        if results.count == 0 {
            return nil
        } else {
            city = results[0] 
        }
        
        return city
    }
    
    public class func createCityWithName(_ name: String) -> City {
        
        let context = CoreDataStack.sharedInstance.managedObjectContext!
        let entityDescription = NSEntityDescription.entity(forEntityName: "City", in: context)
        let newCity = City(entity: entityDescription!, insertInto: context)
        newCity.name = name
        loadPointsOfInterestForCity(newCity)
        CoreDataStack.sharedInstance.saveContext()
        return newCity
    }

    fileprivate class func loadPointsOfInterestForCity(_ city: City) {
        
        if city.pointsOfInterest.count == 0 {
            for (name, coordinate) in packedPointsOfInterest() {
                let pointOfInterest = PointOfInterest.newPointInCity(city)
                pointOfInterest.name = name
                let unpackedCoordinates = CoordinateConverter.unpackCoordinate(coordinate.uint64Value)
                pointOfInterest.coordinates = Coordinates.coordinatesForPoint(pointOfInterest, coordinate: unpackedCoordinates)
                pointOfInterest.seen = NSNumber(value: false as Bool)
                pointOfInterest.planned = NSNumber(value: false as Bool)
            }
        }
    }
    
    fileprivate class func packedPointsOfInterest() -> [String : NSNumber] {
        let filePath = cityKitBundle()?.path(forResource: "PointsOfInterest", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary as! [String : NSNumber]
    }
    
    fileprivate class func cityKitBundle() -> Bundle? {
        return Bundle(identifier: "d-integral.CityKit")
    }
    
    public func pointsInCity() -> [PointOfInterest] {
        return pointsOfInterest.allObjects as! [PointOfInterest]
    }
    
    public func uncheckedSights() -> [PointOfInterest] {
        return pointsInCity().filter { $0.isPlanned() == false && $0.isSeen() == false }
    }

    public func wantToSeeSights() -> [PointOfInterest] {
        return pointsInCity().filter{ $0.isPlanned() }
    }
    
    public func alreadySeenSights() -> [PointOfInterest] {
        return pointsInCity().filter { $0.isSeen() }
    }
}
