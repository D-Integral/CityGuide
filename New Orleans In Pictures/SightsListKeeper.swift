//
//  SightsListKeeper.swift
//  FunSights
//
//  Created by Dmytro Skorokhod on 12/13/14.
//  Copyright (c) 2014-2015 D Integralas. All rights reserved.
//

import UIKit
import CoreData

class SightsListKeeper: NSObject {
    
    class var sharedKeeper:SightsListKeeper {
        struct staticStruct {
            static let _instance = SightsListKeeper()
        }
        
        return staticStruct._instance
    }
    
    // MARK: Public
    
    var pointsOfInterest = [AnyObject]();
    
    // MARK: Settings
    
    let fileName = "SightsList"
    
    // MARK: Private
    
    override init() {
        super.init()
        pointsOfInterest = retrieveData()!
    }
    
    func retrieveData() -> [AnyObject]?
    {
        var accessor: DataObjectAccessor = DataObjectAccessor()
        accessor.entityName = "PointOfInterest"
        var objects = accessor.restoreObjects()
        
        if 0 < objects?.count
        {
            return objects
        }
        else
        {
            let deliveredDict = NSDictionary(contentsOfFile: filePath()! as String)! as! Dictionary<String, AnyObject>
            
            for (key, value) in deliveredDict
            {
                var accessor: DataObjectAccessor = DataObjectAccessor()
                
                accessor.entityName = "PointOfInterest"
                accessor.predicateDict["name"] = key
                accessor.newDatebaseRecord()
            }
            
            objects = accessor.restoreObjects()
            return objects
        }
    }
    
    func filePath() -> NSString?
    {
        return NSBundle.mainBundle().pathForResource(fileName, ofType: "plist")
    }
    
}
