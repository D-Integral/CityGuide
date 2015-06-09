//
//  GalleryVC.swift
//  New Orleans In Pictures
//
//  Created by Skorokhod, Dmytro on 4/24/15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

let cellReuseIdentifier = "pictureCell"
let headerReuseIdentifier = "standardHeader"

class GalleryVC: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, LocationTrackerDelegate {
    
    let headerTexts = ["I want to see", "What To See In New Orleans", "Already Seen"]
    
    var currentManagedObject: NSManagedObject!
    
    var locationTracker: LocationTracker!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        self.setBackgroundImage(UIImage(named: "Texture_New_Orleans_1.png")!)
        
        locationTracker = LocationTracker()
        locationTracker.delegate = self
    }
    
    func locationUpdated(tracker: LocationTracker) {
        locationTracker = tracker
    }
    
    func sightNames() -> NSArray
    {
        var sightNames = [String]()
        
        for pointOfInterest in SightsListKeeper.sharedKeeper.pointsOfInterest
        {
            if true != pointOfInterest.valueForKey("seen") as? Bool && true != pointOfInterest.valueForKey("planned") as? Bool {
                sightNames += [pointOfInterest.valueForKey("name") as! String]
            }
        }
        
        return sightNames
    }
    
    func wantToSeeSights() -> NSArray {
        
        var wantToSeeSights = [String]()
        
        for pointOfInterest in SightsListKeeper.sharedKeeper.pointsOfInterest {
            if true == pointOfInterest.valueForKey("planned") as? Bool {
                wantToSeeSights += [pointOfInterest.valueForKey("name") as! String]
            }
        }
        
        return wantToSeeSights
    }
    
    func alreadySeenSights() -> NSArray {
        
        var alreadySeenSights = [String]()
        
        for pointOfInterest in SightsListKeeper.sharedKeeper.pointsOfInterest {
            if true == pointOfInterest.valueForKey("seen") as? Bool {
                alreadySeenSights += [pointOfInterest.valueForKey("name") as! String]
            }
        }
        
        return alreadySeenSights
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0: return self.wantToSeeSights().count
        case 1: return self.sightNames().count
        case 2: return self.alreadySeenSights().count
        default: return 0
        }
    }
    
    func sightsLocations () -> [AnyObject] {
        
        let pListFile = NSBundle.mainBundle().pathForResource("NewOrleanSightsLocations", ofType: "plist")
        let array = NSArray(contentsOfFile: pListFile!)
        return array! as [AnyObject]
    }
    
    func sightsImagesNames () -> NSArray {
        
        let pListFile = NSBundle.mainBundle().pathForResource("NewOrleanImageNames", ofType: "plist")
        let array = NSArray(contentsOfFile: pListFile!)
        return array!
    }


    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! PictureCell
        
        var sightsCoords = sightsLocations()
        
        switch indexPath.section {
        case 0:
            var sightName = wantToSeeSights()[indexPath.row] as! String
            cell.imageView.image = UIImage(named: sightName)
            
            cell.nameLabel.text = sightName
            
            var index = sightsImagesNames().indexOfObject(sightName)
            var latitude = CLLocationDegrees((sightsCoords[index][0] as! NSString).doubleValue)
            var longitude = CLLocationDegrees((sightsCoords[index][1] as! NSString).doubleValue)
            var sightLocation = CLLocation(latitude: latitude, longitude: longitude)
            if locationTracker.currentLocation != nil {
                var distance = locationTracker.distanceToLocation(sightLocation)
                cell.distanceLabel.text = "\(distance) meters"
            } else {
                cell.distanceLabel.text = ""
            }
        case 1:
            var sightName = sightNames()[indexPath.row] as! String
            cell.imageView.image = UIImage(named: sightName)
            
            cell.nameLabel.text = sightName
            
            var index = sightsImagesNames().indexOfObject(sightName)
            var latitude = CLLocationDegrees((sightsCoords[index][0] as! NSString).doubleValue)
            var longitude = CLLocationDegrees((sightsCoords[index][1] as! NSString).doubleValue)
            var sightLocation = CLLocation(latitude: latitude, longitude: longitude)
            if locationTracker.currentLocation != nil {
                var distance = locationTracker.distanceToLocation(sightLocation)
                cell.distanceLabel.text = "\(distance) meters"
            } else {
                cell.distanceLabel.text = ""
            }
        case 2:
            var sightName = alreadySeenSights()[indexPath.row] as! String
            cell.imageView.image = UIImage(named: sightName)
            
            cell.nameLabel.text = sightName
            
            var index = sightsImagesNames().indexOfObject(sightName)
            var latitude = CLLocationDegrees((sightsCoords[index][0] as! NSString).doubleValue)
            var longitude = CLLocationDegrees((sightsCoords[index][1] as! NSString).doubleValue)
            var sightLocation = CLLocation(latitude: latitude, longitude: longitude)
            if locationTracker.currentLocation != nil {
                var distance = locationTracker.distanceToLocation(sightLocation)
                cell.distanceLabel.text = "\(distance) meters"
            } else {
                cell.distanceLabel.text = ""
            }

        default: break
        }
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        var header: HeaderView?
        
        if UICollectionElementKindSectionHeader == kind
        {
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath) as? HeaderView
            
            switch indexPath.section {
            case 0:
                header?.headerLabel.font = UIFont.boldSystemFontOfSize(20.0)
                header?.headerLabel.text = headerTexts[indexPath.section]
                header?.backgroundColor = UIColor(patternImage: UIImage(named: "Texture_New_Orleans_2.png")!)
            case 1:
                header?.headerLabel.font = UIFont.boldSystemFontOfSize(20.0)
                header?.headerLabel.text = headerTexts[indexPath.section]
                header?.backgroundColor = UIColor(patternImage: UIImage(named: "Texture_New_Orleans_2.png")!)
            case 2:
                header?.headerLabel.font = UIFont.boldSystemFontOfSize(20.0)
                header?.headerLabel.text = headerTexts[indexPath.section]
                header?.backgroundColor = UIColor(patternImage: UIImage(named: "Texture_New_Orleans_2.png")!)
            default: break
            }
        }
        
        return header!
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.currentManagedObject = self.managedObjectForSelecteditemAtIndexPath(indexPath)
        self.performSegueWithIdentifier("toTable", sender: self)
    }
    
    func managedObjectForSelecteditemAtIndexPath(indexPath: NSIndexPath) -> NSManagedObject {
        
        var selectedObject: NSManagedObject!
        var objects = SightsListKeeper.sharedKeeper.pointsOfInterest
        
        switch indexPath.section {
        case 0:
            for object in objects as! [NSManagedObject] {
                if self.wantToSeeSights()[indexPath.row] as? String == object.valueForKey("name") as? String {
                    selectedObject = object
                    break
                }
            }
        case 1:
            for object in objects as! [NSManagedObject] {
                if self.sightNames()[indexPath.row] as? String == object.valueForKey("name") as? String {
                    selectedObject = object
                    break
                }
            }
        case 2:
            for object in objects as! [NSManagedObject] {
                if self.alreadySeenSights()[indexPath.row] as? String == object.valueForKey("name") as? String {
                    selectedObject = object
                    break
                }
            }
        default: break
        }
        
        return selectedObject
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var size: CGSize!
        
        switch indexPath.section {
        case 0:
            if 0 == self.wantToSeeSights().count {
                size = CGSizeZero
            } else {
                size = CGSizeMake(150.0, 300.0)
            }
        case 1:
            if 0 == self.sightNames().count {
                size = CGSizeZero
            } else {
                size = CGSizeMake(150.0, 300.0)
            }
        case 2:
            if 0 == self.alreadySeenSights().count {
                size = CGSizeZero
            } else {
                size = CGSizeMake(150.0, 300.0)
            }
        default: break
        }
        
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size: CGSize!
        
        switch section {
        case 0:
            if 0 == self.wantToSeeSights().count {
                size = CGSizeZero
            } else {
                size = CGSizeMake(50.0, 50.0)
            }
        case 1:
            if 0 == self.sightNames().count {
                size = CGSizeZero
            } else {
                size = CGSizeMake(50.0, 50.0)
            }
        case 2:
            if 0 == self.alreadySeenSights().count {
                size = CGSizeZero
            } else {
                size = CGSizeMake(50.0, 50.0)
            }
        default: break
        }
        
        return size
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.delegate = self
        
        self.collectionView?.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.navigationController?.delegate === self {
            self.navigationController?.delegate = nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC == self && toVC.isKindOfClass(TableViewController) {
            return TransitionFromGalleryToDetail()
        } else {
            return nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let tableVC = segue.destinationViewController as! TableViewController
        var chosenCellIndexPaths = self.collectionView?.indexPathsForSelectedItems()
        var indexPath = (chosenCellIndexPaths as! [NSIndexPath])[0]
        var cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as! PictureCell
        
        tableVC.selectedCellIndexPath = indexPath
        tableVC.image = cell.imageView.image!
        tableVC.currentManagedObject = self.currentManagedObject
        
        switch indexPath.section {
        case 0:
            tableVC.titleLabelText = (wantToSeeSights()[indexPath.row] as? String)!
            tableVC.sightName = (wantToSeeSights()[indexPath.row] as? String)!
        case 1:
            tableVC.titleLabelText = (sightNames()[indexPath.row] as? String)!
            tableVC.sightName = (sightNames()[indexPath.row] as? String)!
        case 2:
            tableVC.titleLabelText = (alreadySeenSights()[indexPath.row] as? String)!
            tableVC.sightName = (alreadySeenSights()[indexPath.row] as? String)!
        default: break
        }
    }
    
    func setBackgroundImage(image: UIImage) {
        self.collectionView?.frame = self.view.frame
        self.collectionView?.backgroundColor = UIColor(patternImage: image)
        
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: .Default)
    }
}
