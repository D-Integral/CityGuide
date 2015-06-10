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
    
    public class func createCityWithName(name: String) {
        
        let context = CoreDataStack.sharedInstance.managedObjectContext!
        let entityDescription = NSEntityDescription.entityForName("City", inManagedObjectContext: context)
        let newCity = City(entity: entityDescription!, insertIntoManagedObjectContext: context)
        newCity.name = name
        loadPointsOfInterestForCity(newCity)

        CoreDataStack.sharedInstance.saveContext()
    }

    private class func loadPointsOfInterestForCity(city: City) {
        if city.allSights.count == 0 {
            let names = sightsNames()
            let coordinates = sightsCoordinates()
            
            for var i = 0; i < names.count; i++ {
                var pointOfInterest = PointOfInterest.newPointInCity(city)
                pointOfInterest.name = names[i]
                pointOfInterest.coordinates = Coordinates.coordinatesForPoint(pointOfInterest, stringCoordinates: sightsCoordinates()[i])
                pointOfInterest.seen = NSNumber(bool: false)
                pointOfInterest.planned = NSNumber(bool: false)
            }
        }
    }
    
    private class func sightsCoordinates () -> [[String]] {
        let filePath = cityKitBundle()?.pathForResource("NewOrleanSightsLocations", ofType: "plist")
        let array = NSArray(contentsOfFile: filePath!)
        return array as! [[String]]
    }
    
    private class func sightsNames () -> [String] {

        let filePath = cityKitBundle()?.pathForResource("NewOrleanImageNames", ofType: "plist")
        let array = NSArray(contentsOfFile: filePath!)
        return array as! [String]
    }
    
    private class func cityKitBundle() -> NSBundle? {
        return NSBundle(identifier: "d-integral.CityKit")
    }
}