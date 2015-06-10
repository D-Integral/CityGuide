//
//  CoreDataStack.swift
//  New Orleans In Pictures
//
//  Created by Aleksander Shcherbakov on 6/9/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack {
    
    let sharedAppGroup: String = "group.com.d-integral.New-Orleans-In-Pictures.documents"
    
    public class var sharedInstance: CoreDataStack {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : CoreDataStack? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CoreDataStack()
        }
        return Static.instance!
    }
    
    
    public lazy var applicationDocumentsDirectory: NSURL = {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as! [NSURL]
        return urls[0]
        }()
    
    
    public lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = NSBundle(identifier: "d-integral.CityKit")
        let modelURL = bundle?.URLForResource("New_Orleans_In_Pictures", withExtension: "momd")
        return NSManagedObjectModel(contentsOfURL: modelURL!)!
    }()
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var error: NSError? = nil
        
        let sharedContainerURL: NSURL? = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(self.sharedAppGroup)
        
        if let sharedConteinerURL = sharedContainerURL {
            let storeURL = sharedContainerURL?.URLByAppendingPathComponent("New_Orleans_In_Pictures")

            var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error) == nil {
                var dict = [String: AnyObject]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
                dict[NSUnderlyingErrorKey] = error
                println("Unresolved error \(error), \(error!.userInfo)")
            }
            return coordinator
        }
        return nil
        }()
    
    public lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    public func saveContext() {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                println("Could not save context: \(error), \(error?.userInfo)")
            }
        }
    }
}