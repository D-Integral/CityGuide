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

let cellReuseIdentifier = "pictureCell"
let headerReuseIdentifier = "standardHeader"

class GalleryVC: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, LocationTrackerDelegate {
    
    struct Constants {
        static let sizeForCell = CGSizeMake(150.0, 195.0)
        static let headerSize = CGSizeMake(50.0, 50.0)
    }
    
    var city: City!
    
    var wantToSee: [PointOfInterest]!
    var alreadySeen: [PointOfInterest]!
    var uncheckedSights: [PointOfInterest]!
    
    var selectedPoint: PointOfInterest!
    
    let headerTexts = ["I want to see", "What To See In New Orleans", "Already Seen"]
    var locationTracker: LocationTracker!
    
    
    func sightsSetup() {
        if let fetchedCity = City.fetchCity() {
            city = fetchedCity
        } else {
            city = City.createCityWithName("New Orleans")
        }
        
        wantToSee = city.wantToSeeSights()
        alreadySeen = city.alreadySeenSights()
        uncheckedSights = city.uncheckedSights()
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        sightsSetup()
        
        self.clearsSelectionOnViewWillAppear = false
        self.setBackgroundImage(UIImage(named: "Texture_New_Orleans_1.png")!)
        locationTracker = LocationTracker()
        locationTracker.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.delegate = self
        self.collectionView?.reloadData()
        
        locationTracker.locationManager.startUpdatingLocation()
        locationTracker.locationManager.startUpdatingHeading()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.navigationController?.delegate === self {
            self.navigationController?.delegate = nil
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        selectedPoint = pointForIndexPath(indexPath)
        self.performSegueWithIdentifier("toTable", sender: self)
        
        locationTracker.locationManager.stopUpdatingLocation()
        locationTracker.locationManager.stopUpdatingHeading()
    }
    
    func pointForIndexPath(indexPath: NSIndexPath) -> PointOfInterest {
        
        var selectedObject: PointOfInterest!
        
        switch indexPath.section {
        case 0: selectedObject = wantToSee[indexPath.row]
        case 1: selectedObject = uncheckedSights[indexPath.row]
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
        
        tableVC.pointOfInterest = selectedPoint
        tableVC.selectedCellIndexPath = indexPath
        tableVC.image = cell.imageView.image!
        tableVC.currentManagedObject = selectedPoint
        tableVC.sightName = selectedPoint.name
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
        case 1: return uncheckedSights.count
        case 2: return alreadySeen.count
        default: return 0
        }
    }
}

//MARK: LocationTrackerDelegate

extension GalleryVC {
    func locationUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        collectionView?.reloadData()
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
        collectionView?.reloadData()
    }
}

//MARK: cell setup

extension GalleryVC {
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! PictureCell
        
        switch indexPath.section {
        case 0: setupCell(&cell, forPoint: wantToSee[indexPath.row])
        case 1: setupCell(&cell, forPoint: uncheckedSights[indexPath.row])
        case 2: setupCell(&cell, forPoint: alreadySeen[indexPath.row])
        default: break
        }
        
        return cell
    }
    
    func setupCell(inout cell: PictureCell, forPoint point: PointOfInterest) {
        
        cell.imageView.image = point.image()
        cell.nameLabel.text = point.name
        let sightLocation = point.locationOnMap()
        
        if locationTracker.currentLocation != nil {
            var distance = locationTracker.distanceToLocation(sightLocation)
            if distance > 999.0 {
                distance = distance / 1000
                if distance < 99.9 {
                    let string = point.name + "\n" + String(format: "%.1f", distance) + " km"
                    cell.nameLabel.text = string
                } else {
                    cell.nameLabel.text = point.name
                }
                
            } else {
                let string = point.name + "\n" + "\(Int(distance)) m"
                cell.nameLabel.text = string
            }
        }
        
        let angle = CGFloat(locationTracker.angleToLocation(sightLocation))
        cell.compassImage.image = UIImage(named: "arrow_up.png")
        cell.compassImage.transform = CGAffineTransformMakeRotation(-angle)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var size: CGSize!
        switch indexPath.section {
        case 0: size = (wantToSee.count == 0) ? CGSizeZero : Constants.sizeForCell
        case 1: size = (uncheckedSights.count == 0) ? CGSizeZero : Constants.sizeForCell
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
        var header: HeaderView?
        
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
        
        return header!
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
        case 1: size = (uncheckedSights.count == 0) ? CGSizeZero : Constants.headerSize
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
