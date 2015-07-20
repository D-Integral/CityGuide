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

class GalleryVC: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, LocationTrackerDelegate {
    
    struct Constants {
        static let sizeForCell = CGSizeMake(150.0, 195.0)
        static let headerSize = CGSizeMake(50.0, 50.0)
    }
    
    let headerTexts = ["I Want To See", "What To See In New Orlean", "Already Seen"]
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var city: City! {
        return City.fetchCity() != nil ? City.fetchCity() : City.createCityWithName("New Orleans")
    }
    
    var wantToSee: [PointOfInterest]!
    var alreadySeen: [PointOfInterest]!
    var unchecked: [PointOfInterest]!
    
    var compassAngles: [String : Double]!
    var routesToPointsOfInterest: [String : MKRoute]!
    
    var angleCalculator: AngleCalculator!
    var routesReceiver = RoutesReceiver.sharedRoutesReceiver
    var locationTracker: LocationTracker! {
        didSet {
            reloadCollectionView()
        }
    }
    
    func reloadCollectionView() {
        reloadAngleCalculator()
        reloadRoutesReceiver()
        
        //sortItemsByStraightDistances()
        
        collectionView?.reloadData()
    }
    
    func reloadAngleCalculator() {
        angleCalculator = AngleCalculator(locationTracker: locationTracker)
        compassAngles = angleCalculator.angles
    }
    
    func reloadRoutesReceiver() {
        routesReceiver.userLocation = locationTracker.currentLocation
        routesReceiver.requestRoutesToPointsOfInterestInCity(city)
        routesToPointsOfInterest = routesReceiver.routes
    }
    
//    func sortItemsByStraightDistances() {
//        wantToSee = sorted(city.wantToSeeSights(), {self.straightDistanceToPOI($0) < self.straightDistanceToPOI($1)})
//        alreadySeen = sorted(city.alreadySeenSights(), {self.straightDistanceToPOI($0) < self.straightDistanceToPOI($1)})
//        unchecked = sorted(city.uncheckedSights(), {self.straightDistanceToPOI($0) < self.straightDistanceToPOI($1)})
//    }
    
    func animateCollectionView() {
        UIView.animateWithDuration(0.5, animations: {self.collectionView?.alpha = 1}, completion: nil)
        activityIndicator.stopAnimating()
    }
    
//    func straightDistanceToPOI(POI: PointOfInterest) -> CLLocationDistance {
//        return locationTracker.distanceToLocation(POI.locationOnMap())
//    }
    
    //MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView?.alpha = 0.5
        activityIndicator.startAnimating()
        
        retrievePointsOfInterest()
        
        self.clearsSelectionOnViewWillAppear = false
        self.setBackgroundImage(UIImage(named: "Texture_New_Orleans_1.png")!)
        
        locationTracker = LocationTracker()
        locationTracker.delegate = self
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

//MARK:  UICollectionViewDatasource

extension GalleryVC {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0: return wantToSee.count
        case 1: return unchecked.count
        case 2: return alreadySeen.count
        default: return 0
        }
    }
}

//MARK: LocationTrackerDelegate

extension GalleryVC {
    func locationUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        animateCollectionView()
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
    }
}

//MARK: cell setup

extension GalleryVC {
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! PictureCell
        
        switch indexPath.section {
        case 0: setupCell(&cell, forPoint: wantToSee[indexPath.row])
        case 1: setupCell(&cell, forPoint: unchecked[indexPath.row])
        case 2: setupCell(&cell, forPoint: alreadySeen[indexPath.row])
        default: break
        }
        
        return cell
    }
    
    func setupCell(inout cell: PictureCell, forPoint point: PointOfInterest) {
        cell.imageView.image = point.image()
        cell.nameLabel.text = point.name
        if routesToPointsOfInterest[point.name] != nil {
            cell.distanceLabel.text = DistanceFormatter.formatted(routesToPointsOfInterest[point.name]!.distance)
            //DistanceFormatter.formatted(straightDistanceToPOI(point))
        }
        rotateCompassView(cell.compassImage, forPointOfInterest: point)
    }
    
    func rotateCompassView(imageView: UIImageView, forPointOfInterest point: PointOfInterest) {
        imageView.image = UIImage(named: "arrow_up.png")
        UIView.animateWithDuration(1, animations: {
            imageView.transform = CGAffineTransformMakeRotation(-CGFloat(self.compassAngles[point.name]!))
        }, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var size: CGSize!
        switch indexPath.section {
        case 0: size = (wantToSee.count == 0) ? CGSizeZero : Constants.sizeForCell
        case 1: size = (unchecked.count == 0) ? CGSizeZero : Constants.sizeForCell
        case 2: size = (alreadySeen.count == 0) ? CGSizeZero : Constants.sizeForCell
        default: break
        }
        
        return size
    }
}

//MARK: header setup

extension GalleryVC {
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        var header: HeaderView!
        
        if UICollectionElementKindSectionHeader == kind
        {
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerReuseIdentifier, forIndexPath: indexPath) as? HeaderView
            
            switch indexPath.section {
            case 0: setupHeader(&header!, inSection: indexPath.section)
            case 1: setupHeader(&header!, inSection: indexPath.section)
            case 2: setupHeader(&header!, inSection: indexPath.section)
            default: break
            }
        }
        
        return header
    }
    
    func setupHeader(inout header: HeaderView, inSection section: Int) {
        header.headerLabel.font = UIFont.boldSystemFontOfSize(20.0)
        header.headerLabel.text = headerTexts[section]
        header.backgroundColor = UIColor(patternImage: UIImage(named: "Texture_New_Orleans_2.png")!)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size: CGSize!
        
        switch section {
        case 0: size = (wantToSee.count == 0) ? CGSizeZero : Constants.headerSize
        case 1: size = (unchecked.count == 0) ? CGSizeZero : Constants.headerSize
        case 2: size = (alreadySeen.count == 0) ? CGSizeZero : Constants.headerSize
        default: break
        }
        
        return size
    }
}

//MARK: animation

extension GalleryVC {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC == self && toVC.isKindOfClass(TableViewController) {
            return TransitionFromGalleryToDetail()
        } else {
            return nil
        }
    }
}
