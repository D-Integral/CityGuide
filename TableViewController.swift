//
//  TableViewController.swift
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

protocol TableViewControllerDelegate {
    func pointOfInterestStateDidChange()
}

class TableViewController: UITableViewController, UINavigationControllerDelegate, MKMapViewDelegate, LocationTrackerDelegate {
    
    struct Constants{
        static let cityEdges = ["right" : -89.90, "left" : -90.29, "top" : 30.08, "bottom" : 29.82]
    }
    
    var delegate: TableViewControllerDelegate?
    
    var initialWantToSeeSwitchState: Bool!
    var initialAlreadySeenSwitchState: Bool!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var wantSeeSwitch: UISwitch!
    @IBOutlet weak var seenSwitch: UISwitch!
    @IBOutlet weak var arrowImage: UIImageView!
    var imageView: UIImageView!
    
    var pointOfInterest: PointOfInterest!
    var angleToPointOfInterest: Double!
    var routeToPointOfInterest: MKRoute!
    
    var image: UIImage = UIImage()
    var backgroundImage = "Texture_New_Orleans_1.png"
    
    var userLocation: MKUserLocation!
    
    //create class ConverterToMKMapItem and make refactoring
    var destination: MKMapItem? {
        var placemark = MKPlacemark(coordinate: pointOfInterest.coordinates.locationOnMap().coordinate, addressDictionary: nil)
        return MKMapItem(placemark: placemark)
    }
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    
    var selectedCellIndexPath: NSIndexPath!
    
    var locationTracker: LocationTracker! {
        didSet {
            reloadData()
        }
    }
    
    var angleCalculator: AngleCalculator!
    
    func reloadData() {
        angleCalculator = AngleCalculator()
        angleCalculator.locationTracker = locationTracker
        angleToPointOfInterest = angleCalculator.angleToLocation(pointOfInterest)
        rotateCompassView(arrowImage)
    }
    
    func rotateCompassView(imageView: UIImageView) {
        UIView.animateWithDuration(1, animations: {
            imageView.transform = CGAffineTransformMakeRotation(-CGFloat(self.angleToPointOfInterest))
        }, completion: nil)
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var popRecognizer: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handlePopRecognizer:")
        popRecognizer.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(popRecognizer)
        
        self.title = pointOfInterest.name
        
        self.setupLocationTracker()
        
        //need to be refactored in one method
        self.setupTableViewBackground()
        self.setBackgroundImage(UIImage(named: "Texture_New_Orleans_1.png")!, forView: self.tableView)
        
        self.setupArrowImage()
        self.imageViewInitialize()
        self.mapViewSetup()
        self.showSelectedSightAnnotation()
        self.initialSwitchesSetup()
    }
    
    func setupLocationTracker() {
        locationTracker = LocationTracker()
        locationTracker.delegate = self
    }
    
    func setBackgroundImage(image: UIImage, forView view: UIView) {
        self.view.backgroundColor = UIColor(patternImage: image)
        view.backgroundColor = UIColor(patternImage: image)
    }
    
    func setupArrowImage() {
        arrowImage.image = UIImage(named: "arrow_up.png")
    }
    
    func imageViewInitialize() {
        let x: CGFloat = (self.view.frame.size.width - 150) / 2
        let frame = CGRectMake(x, 0, 150, 150)
        imageView = UIImageView(frame: frame)
        imageView.image = self.image
        self.view.addSubview(imageView)
    }
    
    func initialSwitchesSetup() {
        wantSeeSwitch.on = pointOfInterest.isPlanned() ? true : false
        seenSwitch.on = pointOfInterest.isSeen() ? true : false
        
        initialWantToSeeSwitchState = wantSeeSwitch.on
        initialAlreadySeenSwitchState = seenSwitch.on
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.delegate = self
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
        //println("Delegate notified about changing POI state.")
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
}



