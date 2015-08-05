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
import CityKit
import MapKit

let cellReuseIdentifier = "pictureCell"
let headerReuseIdentifier = "standardHeader"

class GalleryVC: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, LocationTrackerDelegate, RoutesReceiverDelegate, TableViewControllerDelegate {
    
    struct Constants {
        static let sizeForCell = CGSizeMake(150.0, 195.0)
        static let headerSize = CGSizeMake(300.0, 50.0)
    }
    
    let headerTexts = ["I Want To See", "What To See", "Already Seen"]
    
    var city: City! {
        return City.fetchCity() != nil ? City.fetchCity() : City.createCityWithName("New Orleans")
    }
    
    //MARK: CollectionView source
    
    var wantToSee: [PointOfInterest]!
    var alreadySeen: [PointOfInterest]!
    var unchecked: [PointOfInterest]!
    
    var compassAngles: [String : Double]!
    var routesToPointsOfInterest = [String : MKRoute]()
    
    var angleCalculator = AngleCalculator()
    var routesReceiver = RoutesReceiver.sharedRoutesReceiver
    var locationTracker: LocationTracker!
    
    func sortItemsByRouteDistances() {
        wantToSee = sorted(city.wantToSeeSights(), {self.routeDistanceToPointOfInterest($0) < self.routeDistanceToPointOfInterest($1)})
        alreadySeen = sorted(city.alreadySeenSights(), {self.routeDistanceToPointOfInterest($0) < self.routeDistanceToPointOfInterest($1)})
        unchecked = sorted(city.uncheckedSights(), {self.routeDistanceToPointOfInterest($0) < self.routeDistanceToPointOfInterest($1)})
        }
    
    func routeDistanceToPointOfInterest(pointOFInterest: PointOfInterest) -> CLLocationDistance {
        return routesToPointsOfInterest[pointOFInterest.name]!.distance
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "New Orleans Compass"
        
        retrievePointsOfInterest()
        
        self.clearsSelectionOnViewWillAppear = false
        self.setBackgroundImage(UIImage(named: "Texture_New_Orleans_1.png")!)
        
        locationTracker = LocationTracker()
        locationTracker.delegate = self
        
        routesReceiver.delegate = self
        
        angleCalculator.locationTracker = locationTracker
        compassAngles = angleCalculator.angles
    }
    
    func retrievePointsOfInterest() {
        wantToSee = city.wantToSeeSights()
        alreadySeen = city.alreadySeenSights()
        unchecked = city.uncheckedSights()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.delegate = self
        
        locationTracker.startUpdating()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.navigationController?.delegate === self {
            self.navigationController?.delegate = nil
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("toTable", sender: self)
        
        locationTracker.stopUpdating()
    }
    
    func pointForIndexPath(indexPath: NSIndexPath) -> PointOfInterest {
        
        var selectedObject: PointOfInterest!
        
        switch indexPath.section {
        case 0: selectedObject = wantToSee[indexPath.row]
        case 1: selectedObject = unchecked[indexPath.row]
        case 2: selectedObject = alreadySeen[indexPath.row]
        default: break
        }
        
        return selectedObject
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let tableVC = segue.destinationViewController as! TableViewController
        var chosenCellIndexPaths = self.collectionView?.indexPathsForSelectedItems()
        var indexPath = (chosenCellIndexPaths as! [NSIndexPath])[0]
        var cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as! PictureCell
        
        tableVC.delegate = self
        tableVC.pointOfInterest = pointForIndexPath(indexPath)
        tableVC.selectedCellIndexPath = indexPath
        tableVC.image = cell.imageView.image!
        tableVC.routeToPointOfInterest = routesToPointsOfInterest[pointForIndexPath(indexPath).name]
    }
    
    func setBackgroundImage(image: UIImage) {
        self.collectionView?.frame = self.view.frame
        self.collectionView?.backgroundColor = UIColor(patternImage: image)
        
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: .Default)
    }
}



