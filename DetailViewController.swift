//
//  DetailViewController.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 28.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
import CityKit

protocol DetailViewControllerDelegate {
    func pointOfInterestStateDidChange()
}

class DetailViewController: UITableViewController, UINavigationControllerDelegate, MKMapViewDelegate, LocationTrackerDelegate, RoutesReceiverFetchedRoute {
    
    //MARK: Data
    var city: City!
    var pointOfInterest: PointOfInterest!
    var pointOfInterestAnnotation: MKAnnotation!
    var userLocation: MKUserLocation!
    var selectedCellIndexPath: NSIndexPath!
    var destination: MKMapItem? {
        var placemark = MKPlacemark(coordinate: pointOfInterest.coordinates.locationOnMap().coordinate, addressDictionary: nil)
        return MKMapItem(placemark: placemark)
    }
    var locationTracker: LocationTracker!
    var locationDataVC = LocationDataViewController()
    var routeReceiver = RoutesReceiver.sharedRoutesReceiver
    
    //MARK: Interface
    var shoudScreenRotate = true
    var initialWantToSeeSwitchState: Bool!
    var initialAlreadySeenSwitchState: Bool!
    @IBOutlet weak var locationDataView: ViewForLocationData!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var wantSeeSwitch: UISwitch!
    @IBOutlet weak var seenSwitch: UISwitch!
    var imageViewForAnimation: UIImageView!
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    
    var delegate: DetailViewControllerDelegate?
    
    var afterGalleryVC: Bool!
    
    var mapViewDidShowRoute: Bool!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPopRecognizer()
        setupInterface()
        
        self.setupLocationTracker()
        routeReceiver.delegateForRoute = self
        
        locationDataVC.adjustLocationDataView(&locationDataView!, forPointOfInterest: pointOfInterest, withLocationTracker: locationTracker)
        
        mapViewSetup()
        showSelectedSightAnnotation()
    }
    
    func addPopRecognizer() {
        var popRecognizer: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handlePopRecognizer:")
        popRecognizer.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(popRecognizer)
    }
    
    func setupInterface() {
        title = NSLocalizedString(pointOfInterest.name, comment: pointOfInterest.name)
        setupTableViewBackground()
        locationDataView.distanceLabel.font = UIFont.boldSystemFontOfSize(22)
        initialSwitchesSetup()
    }
    
    func setupLocationTracker() {
        locationTracker = LocationTracker()
        locationTracker.delegate = self
    }
    
    func setupTableViewBackground() {
        self.tableView.backgroundView = UIView(frame: self.tableView.frame)
        self.tableView.backgroundView?.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    func imageViewInitialize() {
        let x: CGFloat = (self.view.frame.size.width - 150) / 2
        let y: CGFloat = (self.mapView.frame.height - 150) / 2
        let frame = CGRectMake(x, y, 150, 150)
        imageViewForAnimation = UIImageView(frame: frame)
        imageViewForAnimation.image = pointOfInterest.image()
        self.view.addSubview(imageViewForAnimation)
    }
    
    func initialSwitchesSetup() {
        wantSeeSwitch.on = pointOfInterest.isPlanned() ? true : false
        seenSwitch.on = pointOfInterest.isSeen() ? true : false
        
        initialWantToSeeSwitchState = wantSeeSwitch.on
        initialAlreadySeenSwitchState = seenSwitch.on
    }
    
    override func viewWillAppear(animated: Bool) {
        println("Detail viewWillAppear")
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        shoudScreenRotate = !shoudScreenRotate
        afterGalleryVC = true
        mapViewDidShowRoute = false

        routeReceiver.delegateForRoute = self
        
        self.imageViewInitialize()
        self.mapView.viewForAnnotation(pointOfInterestAnnotation).hidden = true        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.delegate = self
        mapView.showsUserLocation = true
        self.mapView.viewForAnnotation(pointOfInterestAnnotation).hidden = false
        self.imageViewForAnimation.removeFromSuperview()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.navigationController?.delegate === self {
            self.navigationController?.delegate = nil
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        if pointOfInterestStateDidChange() { notifyDelegate() }
    }
    
    func pointOfInterestStateDidChange() -> Bool {
        return initialWantToSeeSwitchState != pointOfInterest.planned || initialAlreadySeenSwitchState != pointOfInterest.seen
    }
    
    func notifyDelegate() {
        delegate?.pointOfInterestStateDidChange()
    }
    
    @IBAction func wantToSee(sender: AnyObject) {
        pointOfInterest.planned = true == (sender as! UISwitch).on ? NSNumber(bool: true) : NSNumber(bool: false)
        CoreDataStack.sharedInstance.saveContext()
    }
    
    @IBAction func alreadySeen(sender: AnyObject) {
        true == (sender as! UISwitch).on ? seenSwitchOn() : seenSwitchOff()
        CoreDataStack.sharedInstance.saveContext()
    }
    
    func seenSwitchOn() {
        wantSeeSwitch.on = false
        pointOfInterest.planned = NSNumber(bool: false)
        pointOfInterest.seen = NSNumber(bool: true)
    }
    
    func seenSwitchOff() {
        pointOfInterest.seen = NSNumber(bool: false)
    }
    
    override func shouldAutorotate() -> Bool {
        return shoudScreenRotate
    }
}





