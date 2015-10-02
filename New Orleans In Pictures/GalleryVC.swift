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

class GalleryVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, LocationTrackerDelegate, RoutesReceiverFetchedAllRoutesDelegate, DetailViewControllerDelegate {
    
    //MARK: Constants
    let appName = "New Orleans Landmark"
    
    struct Constants {
        static let sizeForSmallCell = CGSizeMake(150.0, 203.0)
        static let headerSize = CGSizeMake(300.0, 50.0)
    }
    
    let headerTexts = ["I Plan To See", "What To See", "Already Seen"]
    
    var city: City! {
        return City.fetchCity() != nil ? City.fetchCity() : City.createCityWithName("New Orleans")
    }
    
    var formerUserLocation: CLLocation?
    
    //MARK: CollectionView datasource
    
    var wantToSee: [PointOfInterest]!
    var alreadySeen: [PointOfInterest]!
    var unchecked: [PointOfInterest]!
    var routesToPointsOfInterest = [String : MKRoute]()
    
    var routesReceiver = RoutesReceiver.sharedRoutesReceiver
    var locationTracker = LocationTracker.sharedLocationTracker
    var locationDataVC = LocationDataViewController()
    
    func sortItemsByRouteDistances() {
        wantToSee = city.wantToSeeSights().sort {self.routeDistanceToPointOfInterest($0) < self.routeDistanceToPointOfInterest($1)}
        alreadySeen = city.alreadySeenSights().sort {self.routeDistanceToPointOfInterest($0) < self.routeDistanceToPointOfInterest($1)}
        unchecked = city.uncheckedSights().sort {self.routeDistanceToPointOfInterest($0) < self.routeDistanceToPointOfInterest($1)}
    }
    
    func routeDistanceToPointOfInterest(pointOFInterest: PointOfInterest) -> CLLocationDistance {
        return routesToPointsOfInterest[pointOFInterest.name]!.distance
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        if isCurrentDevicePad() {
//            let customLayout = CustomFlowLayout()
//            collectionView?.collectionViewLayout = customLayout
//        }
		
        retrievePointsOfInterest()
        
        self.title = appName
        self.clearsSelectionOnViewWillAppear = false
        self.setBackgroundImage(UIImage(named: "background.png")!)
        
        routesReceiver.delegateForAllRoutes = self
        routesReceiver.city = self.city
    }
    
    func isCurrentDevicePad() -> Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == .Pad ? true : false
    }
    
    func retrievePointsOfInterest() {
        wantToSee = city.wantToSeeSights()
        alreadySeen = city.alreadySeenSights()
        unchecked = city.uncheckedSights()
    }
    
    override func viewWillAppear(animated: Bool) {
        locationTracker.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.delegate = self
        
        collectionView?.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.navigationController?.delegate === self {
            self.navigationController?.delegate = nil
        }
        
        locationTracker.delegate = nil
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("toTable", sender: self)
    }
    
    func pointAtIndexPath(indexPath: NSIndexPath) -> PointOfInterest? {
        switch indexPath.section {
        case 0: return wantToSee[indexPath.row]
        case 1: return unchecked[indexPath.row]
        case 2: return alreadySeen[indexPath.row]
        default: return nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let detailVC = segue.destinationViewController as! DetailViewController
        var chosenCellIndexPaths = self.collectionView?.indexPathsForSelectedItems()
        let selectedCellIndexPath = chosenCellIndexPaths![0]
        
        detailVC.delegate = self
        detailVC.city = self.city
        detailVC.pointOfInterest = pointAtIndexPath(selectedCellIndexPath)
        detailVC.selectedCellIndexPath = selectedCellIndexPath
        detailVC.initialUserLocation = locationTracker.currentLocation
    }
    
    func setBackgroundImage(image: UIImage) {
        self.collectionView?.backgroundView = UIView(frame: self.collectionView!.frame)
        self.collectionView?.backgroundView?.backgroundColor = UIColor(patternImage: image)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
}



