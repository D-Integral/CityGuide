//
//  DataObjectAccessor.swift
//  New Orleans In Pictures
//
//  Created by Skorokhod, Dmytro on 8/15/2014.
//  Copyright (c) 2014-2015 D Integralas. All rights reserved.
//

import UIKit
import CoreData

class DataObjectAccessor: NSObject {
    
    // MARK: Public
    
    var entityName: String?
    var predicateDict = [String: String]()
    
    // MARK: Private
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func restoreObjects() -> [AnyObject]?
    {
        var error: NSError?
        
        if let objects = managedObjectContext?.executeFetchRequest(self.request(), error: &error)
        {
            if 0 < objects.count
            {
                return objects
            }
            else
            {
                return nil
            }
        }
        else
        {
            return nil
        }
    }
    
    func request() -> NSFetchRequest
    {
        let request: NSFetchRequest = NSFetchRequest()
        
        request.entity = self.entityDescription()
        request.predicate = self.predicate()
        
        return request
    }
    
    func entityDescription() -> NSEntityDescription
    {
        return NSEntityDescription.entityForName(entityName!, inManagedObjectContext: managedObjectContext!)!
    }
    
    func predicate() -> NSPredicate?
    {
        if 0 < predicateDict.count
        {
            var formatString = ""
            var arguments = [String]()
            
            for (key, value) in predicateDict
            {
                formatString += "(%@ = %@)"
                arguments += [key, value]
            }
            
            return NSPredicate(format:formatString, arguments)
        }
        else
        {
            return nil
        }
    }
    
    func newDatebaseRecord() -> NSManagedObject
    {
        var managedObject =  NSEntityDescription.insertNewObjectForEntityForName(entityName!, inManagedObjectContext: managedObjectContext!) as! PointOfInterest
        
        for (key, value) in predicateDict
        {
            managedObject.setValue(value, forKey: key)
        }
        
        return managedObject
    }
}
