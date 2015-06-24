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
        let cityFetch = NSFetchRequest(entityName: "City")
        var error: NSError?
        let context = CoreDataStack.sharedInstance.managedObjectContext
        
        var city: City?
        let results = context?.executeFetchRequest(cityFetch, error: &error) as! [City]
        if results.count == 0 {
            return nil
        } else {
            city = results[0] as City
            println("\(city?.pointsOfInterest)")
        }
        
        return city
    }
    
    public class func createCityWithName(name: String) -> City {
        
        let context = CoreDataStack.sharedInstance.managedObjectContext!
        let entityDescription = NSEntityDescription.entityForName("City", inManagedObjectContext: context)
        let newCity = City(entity: entityDescription!, insertIntoManagedObjectContext: context)
        newCity.name = name
        loadPointsOfInterestForCity(newCity)

        CoreDataStack.sharedInstance.saveContext()
        return newCity
    }

    private class func loadPointsOfInterestForCity(city: City) {
        if city.pointsOfInterest.count == 0 {
            let names = pointsOfInterestNames()
            let coordinates = pointsOfInterestCoordinates()
            
            for i in 0..<names.count {
                var pointOfInterest = PointOfInterest.newPointInCity(city)
                pointOfInterest.name = names[i]
                pointOfInterest.coordinates = Coordinates.coordinatesForPoint(pointOfInterest, stringCoordinates: coordinates[i])
                pointOfInterest.seen = NSNumber(bool: false)
                pointOfInterest.planned = NSNumber(bool: false)
            }
        }
    }
    
    // rename and create a single arrayFrom file method when a coordinate will be one number instead of two
    
//    private class func pointsOfInterestCoordinates() -> [[String]] {
//        let filePath = cityKitBundle()?.pathForResource("RigaSightsLocations", ofType: "plist")
//        let array = NSArray(contentsOfFile: filePath!)
//        return array as! [[String]]
//    }
    
//    private class func pointsOfInterestNames() -> [String] {
//        let filePath = cityKitBundle()?.pathForResource("NewOrleanImageNames", ofType: "plist")
//        let array = NSArray(contentsOfFile: filePath!)
//        return array as! [String]
//    }
    
    private class func pointsOfInterestCoordinates() -> [[String]] {
        return arrayFromFile("RigaSightsLocations") as! [[String]]
    }

    
    private class func pointsOfInterestNames() -> [String] {
        return arrayFromFile("NewOrleanImageNames") as! [String]
    }
    
    private class func arrayFromFile(fileName: String) -> [AnyObject]? {
        let filePath = cityKitBundle()?.pathForResource(fileName, ofType: "plist")
        let array = NSArray(contentsOfFile: filePath!)
        return array as? [AnyObject]
    }
    
    private class func cityKitBundle() -> NSBundle? {
        return NSBundle(identifier: "d-integral.CityKit")
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