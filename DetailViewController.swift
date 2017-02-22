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
    func userLocationDidChangeToLocation(_ location: CLLocation)
}

class DetailViewController: UITableViewController, UINavigationControllerDelegate, MKMapViewDelegate, LocationTrackerDelegate, RoutesReceiverFetchedRoute {
    
    //MARK: Data
    var city: City!
    var pointOfInterest: PointOfInterest!
    var pointOfInterestAnnotation: MKAnnotation!
    var userLocation: MKUserLocation!
    var selectedCellIndexPath: IndexPath!
    var destination: MKMapItem? {
        let placemark = MKPlacemark(coordinate: pointOfInterest.coordinates.locationOnMap().coordinate, addressDictionary: nil)
        return MKMapItem(placemark: placemark)
    }
    var locationTracker = LocationTracker.sharedLocationTracker
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
    
    var formerUserLocation: CLLocation!
    
    var initialUserLocation: CLLocation!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPopRecognizer()
        setupInterface()
        
        routeReceiver.delegateForRoute = self
        locationTracker.delegate = self
        
        locationDataVC.adjustLocationDataView(&locationDataView!, forPointOfInterest: pointOfInterest, withLocationTracker: locationTracker)
        
        mapViewSetup()
        showSelectedSightAnnotation()
        
        formerUserLocation = initialUserLocation
    }
    
    func addPopRecognizer() {
        let popRecognizer: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handlePopRecognizer:")
        popRecognizer.edges = UIRectEdge.left
        self.view.addGestureRecognizer(popRecognizer)
    }
    
    func setupInterface() {
        title = NSLocalizedString(pointOfInterest.name, comment: pointOfInterest.name)
        setupTableViewBackground()
        locationDataView.distanceLabel.font = UIFont.boldSystemFont(ofSize: 22)
        initialSwitchesSetup()
    }
    
    func setupTableViewBackground() {
        self.tableView.backgroundView = UIView(frame: self.tableView.frame)
        self.tableView.backgroundView?.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    func imageViewInitialize() {
        let x: CGFloat = (self.view.frame.size.width - 150) / 2
        let y: CGFloat = (self.mapView.frame.height - 150) / 2
        let frame = CGRect(x: x, y: y, width: 150, height: 150)
        imageViewForAnimation = UIImageView(frame: frame)
        imageViewForAnimation.image = pointOfInterest.image()
        self.view.addSubview(imageViewForAnimation)
    }
    
    func initialSwitchesSetup() {
        wantSeeSwitch.isOn = pointOfInterest.isPlanned() ? true : false
        seenSwitch.isOn = pointOfInterest.isSeen() ? true : false
        
        initialWantToSeeSwitchState = wantSeeSwitch.isOn
        initialAlreadySeenSwitchState = seenSwitch.isOn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isCurrentDevicePad() {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            shoudScreenRotate = !shoudScreenRotate
        }
        
        afterGalleryVC = true
        mapViewDidShowRoute = false
        
        routeReceiver.delegateForRoute = self
        
        self.imageViewInitialize()
        self.mapView.view(for: pointOfInterestAnnotation)!.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.delegate = self
        mapView.showsUserLocation = true
        self.mapView.view(for: pointOfInterestAnnotation)!.isHidden = false
        self.imageViewForAnimation.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.navigationController?.delegate === self {
            self.navigationController?.delegate = nil
        }
        
        locationTracker.delegate = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if pointOfInterestStateDidChange() { delegate?.pointOfInterestStateDidChange() }
        
        if userLocationDidChange(){ delegate?.userLocationDidChangeToLocation(locationTracker.currentLocation!) }
    }
    
    func isCurrentDevicePad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad ? true : false
    }
    
    func isCurrentOrientationLandscape() -> Bool {
        return UIDeviceOrientationIsLandscape(UIDevice.current.orientation) ? true : false
    }
    
    func isCurrentDevicePadInLandscapeMode() -> Bool {
        return isCurrentDevicePad() && isCurrentOrientationLandscape() ? true : false
    }
    
    func pointOfInterestStateDidChange() -> Bool {
        return initialWantToSeeSwitchState != pointOfInterest.planned || initialAlreadySeenSwitchState != pointOfInterest.seen
    }
    
    func userLocationDidChange() -> Bool {
        
        return initialUserLocation != nil && locationTracker.currentLocation != nil && initialUserLocation.distance(from: locationTracker.currentLocation!) > 200.0 ? true : false
    }
    
    @IBAction func wantToSee(_ sender: AnyObject) {
        pointOfInterest.planned = true == (sender as! UISwitch).isOn ? NSNumber(value: true as Bool) : NSNumber(value: false as Bool)
        CoreDataStack.sharedInstance.saveContext()
    }
    
    @IBAction func alreadySeen(_ sender: AnyObject) {
        true == (sender as! UISwitch).isOn ? seenSwitchOn() : seenSwitchOff()
        CoreDataStack.sharedInstance.saveContext()
    }
    
    func seenSwitchOn() {
        wantSeeSwitch.isOn = false
        pointOfInterest.planned = NSNumber(value: false as Bool)
        pointOfInterest.seen = NSNumber(value: true as Bool)
    }
    
    func seenSwitchOff() {
        pointOfInterest.seen = NSNumber(value: false as Bool)
    }
    
    override var shouldAutorotate : Bool {
        return shoudScreenRotate
    }
}




