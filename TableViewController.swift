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

class TableViewController: UITableViewController, UINavigationControllerDelegate, MKMapViewDelegate, LocationTrackerDelegate {
    
    struct Constants{
        static let cityEdges = ["right" : -89.90, "left" : -90.29, "top" : 30.08, "bottom" : 29.82]
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var wantSeeSwitch: UISwitch!
    @IBOutlet weak var seenSwitch: UISwitch!
    @IBOutlet weak var arrowImage: UIImageView!
    var imageView: UIImageView!
    
    var pointOfInterest: PointOfInterest!
    var angleToPointOfInterest: Double!
    
    var image: UIImage = UIImage()
    var backgroundImage = "Texture_New_Orleans_1.png"
    
    var userLocation: MKUserLocation!
    
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
        angleCalculator = AngleCalculator(locationTracker: locationTracker)
        angleToPointOfInterest = angleCalculator.angleToLocation(pointOfInterest.locationOnMap())
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
        
        self.setupLocationTracker()
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
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.navigationController?.delegate === self {
            self.navigationController?.delegate = nil
        }
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

//MARK: LocationTrackerDelegate

extension TableViewController {
    func locationUpdated(tracker: LocationTracker) {
        locationTracker = tracker
    }
    
    func headingUpdated(tracker: LocationTracker) {
        locationTracker = tracker
    }
}

//MARK: Animations

extension TableViewController {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC === self && toVC.isKindOfClass(GalleryVC) {
            return TransitionFromDetailToGallery()
        } else {
            return nil
        }
    }
    
    func handlePopRecognizer(recognizer: UIScreenEdgePanGestureRecognizer) {
        
        var progress = recognizer.translationInView(self.view).x / self.view.bounds.size.width * 1.0
        progress = min(1.0, max(0.0, progress))
        
        if recognizer.state == UIGestureRecognizerState.Began {
            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
        } else if recognizer.state == UIGestureRecognizerState.Changed {
            self.interactivePopTransition.updateInteractiveTransition(progress)
        } else if recognizer.state == UIGestureRecognizerState.Ended || recognizer.state == UIGestureRecognizerState.Cancelled {
            if progress > 0.5 {
                self.interactivePopTransition.finishInteractiveTransition()
            } else {
                self.interactivePopTransition.cancelInteractiveTransition()
            }
            self.interactivePopTransition = nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if animationController.isKindOfClass(TransitionFromDetailToGallery) {
            return self.interactivePopTransition
        } else {
            return nil
        }
    }
}

//MARK: Map methods

extension TableViewController {
    func mapViewSetup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func showSelectedSightAnnotation() {
        
        let annotation = SightAnnotation(coordinate: pointOfInterest.coordinates.locationOnMap().coordinate)
        self.mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 4000, 4000)
        mapView.setRegion(region, animated: true)
        
        self.setupTitleLabel()
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFontOfSize(20.0)
        titleLabel.text = pointOfInterest.name
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        self.userLocation = userLocation
        isUserInTheCity() ? userInTheCity() : showSelectedSightAnnotation()
    }
    
    func userInTheCity() {
        zoomToFitMapItems()
        getDirections()
    }
    
    func isUserInTheCity() -> Bool {
        let userLongitude = userLocation.location.coordinate.longitude
        let userLatitude = userLocation.location.coordinate.latitude

        return (userLongitude < Constants.cityEdges["right"] && userLongitude > Constants.cityEdges["left"] && userLatitude < Constants.cityEdges["top"] && userLatitude > Constants.cityEdges["bottom"]) ? true : false
    }
    
    func getDirections() {
        
        let request = MKDirectionsRequest()
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        request.setDestination(destination!)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in            
            error != nil ? println("Error getting directions") : self.showRoute(response)
        })
    }
    
    func showRoute(response: MKDirectionsResponse) {
        
        for route in response.routes as! [MKRoute] {
            
            mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
            
            let distance = route.distance
            
            self.setupTitleLabel()
            self.titleLabel.alpha = 0.0
            self.titleLabel.text = self.pointOfInterest.name + " : \(DistanceFormatter.formatted(distance))"
            
            UIView.animateWithDuration(1, animations: {
                self.titleLabel.alpha = 1.0
            }, completion: nil)
            
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blueColor()
        renderer.lineWidth = 7.0
        
        return renderer
    }
    
    func zoomToFitMapItems() {
        
        var topLeftCoord = CLLocationCoordinate2D()
        var bottomRightCoord = CLLocationCoordinate2D()
        
        topLeftCoord.longitude = fmin(userLocation.coordinate.longitude, pointOfInterest.coordinates.longitude.doubleValue)
        topLeftCoord.latitude = fmax(userLocation.coordinate.latitude, pointOfInterest.coordinates.latitude.doubleValue)
        
        bottomRightCoord.longitude = fmax(userLocation.coordinate.longitude, pointOfInterest.coordinates.longitude.doubleValue)
        bottomRightCoord.latitude = fmin(userLocation.coordinate.latitude, pointOfInterest.coordinates.latitude.doubleValue)
        
        var region = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2
        
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }
}

//MARK: TableView

extension TableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? 2 : 1
    }
    
    func setupTableViewBackground() {
        for section in 0..<tableView.numberOfSections(){
            switch section {
            case 0:
                setupBackgroundforCellInSection(section)
            case 1:
                setupBackgroundforCellInSection(section)
            case 2:
                setupBackgroundforCellInSection(section)
            default: break
            }
        }
    }
    
    func setupBackgroundforCellInSection(section: Int) {
        var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section))
        setupBackgroundForCell(&cell!)
        
        if section == 2 {
            for i in 0...1 {
                var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: section))
                setupBackgroundForCell(&cell!)
            }
        }
    }
    
    func setupBackgroundForCell(inout cell: UITableViewCell) {
        cell.contentView.backgroundColor = UIColor(patternImage: UIImage(named: backgroundImage)!)
    }
}
