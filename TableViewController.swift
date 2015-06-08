//
//  TableViewController.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 28.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class TableViewController: UITableViewController, UINavigationControllerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var wantSeeSwitch: UISwitch!
    @IBOutlet weak var seenSwitch: UISwitch!
    
    var imageView: UIImageView!
    var image: UIImage = UIImage()
    var titleLabelText = String()
    
    var selectedPOI: CLLocation = CLLocation()
    var userLocation: MKUserLocation!
    
    var destination: MKMapItem?
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    
    var selectedCellIndexPath: NSIndexPath!
    
    var routeSteps: [AnyObject]!
    
    var sightName: String!
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var currentManagedObject: NSManagedObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var popRecognizer: UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handlePopRecognizer:")
        popRecognizer.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(popRecognizer)
        
        self.setBackgroundImage(UIImage(named: "Texture_New_Orleans_1.png")!, forView: self.tableView)
        self.imageViewInitialize()
        self.mapViewSetup()
        self.showSelectedSightAnnotation()
        self.initialSwitchesSetup()
    }
    
    func initialSwitchesSetup() {
        
        if true == currentManagedObject.valueForKey("planned") as? Bool {
            wantSeeSwitch.on = true
        } else {
            wantSeeSwitch.on = false
        }
        
        if true == currentManagedObject.valueForKey("seen") as? Bool {
            seenSwitch.on = true
        } else {
            seenSwitch.on = false
        }
    }
    
    func imageViewInitialize() {
        let x: CGFloat = (self.view.frame.size.width - 150) / 2
        let frame = CGRectMake(x, 0, 150, 150)
        imageView = UIImageView(frame: frame)
        imageView.image = self.image
        self.view.addSubview(imageView)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.navigationController?.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        if self.navigationController?.delegate === self {
            self.navigationController?.delegate = nil
        }
    }
    
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
    
    func mapViewSetup() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func sightsImagesNames () -> NSArray {
        
        let pListFile = NSBundle.mainBundle().pathForResource("NewOrleanImageNames", ofType: "plist")
        let array = NSArray(contentsOfFile: pListFile!)
        return array!
    }
    
    func sightsLocations () -> [AnyObject] {
        
        let pListFile = NSBundle.mainBundle().pathForResource("NewOrleanSightsLocations", ofType: "plist")
        let array = NSArray(contentsOfFile: pListFile!)
        return array! as [AnyObject]
    }
    
    func showSelectedSightAnnotation() {
        
        var selectedSightIndex = sightsImagesNames().indexOfObject(titleLabelText)
        var sightsCoords = sightsLocations()
        
        var latitude = CLLocationDegrees((sightsCoords[selectedSightIndex][0] as! NSString).doubleValue)
        var longitude = CLLocationDegrees((sightsCoords[selectedSightIndex][1] as! NSString).doubleValue)
        var coords = CLLocationCoordinate2DMake(latitude, longitude)
        var image = self.image
        
        let annotation = SightAnnotation(coordinate: coords, image: image)
        self.mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 4000, 4000)
        mapView.setRegion(region, animated: true)
        
        self.setupTitleLabel()
        titleLabel.text = titleLabelText
        
        selectedPOI = CLLocation(latitude: latitude, longitude: longitude)
        
        var placemark = MKPlacemark(coordinate: coords, addressDictionary: nil)
        destination = MKMapItem(placemark: placemark)
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        self.userLocation = userLocation
        
        if self.isUserInTheCity() {
            self.zoomToFitMapItems()
            self.getDirections()
        } else {
            showSelectedSightAnnotation()
        }
    }
    
    func isUserInTheCity() -> Bool {
        var isInTheCity: Bool!
        
        let rightCityEdge: CLLocationDegrees = -89.90
        let leftCityEdge: CLLocationDegrees = -90.29
        let topCityEdge: CLLocationDegrees = 30.08
        let bottomCityEdge:CLLocationDegrees = 29.82
        
        let userLongitude = userLocation.location.coordinate.longitude
        let userLatitude = userLocation.location.coordinate.latitude
        
        if userLongitude < rightCityEdge && userLongitude > leftCityEdge && userLatitude < topCityEdge && userLatitude > bottomCityEdge {
            isInTheCity = true
        } else {
            isInTheCity = false
        }
        
        return isInTheCity
    }
    
    func getDirections() {
        
        let request = MKDirectionsRequest()
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        request.setDestination(destination!)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
            if error != nil {
                println("Error getting directions")
            } else {
                self.showRoute(response)
            }
        })
    }
    
    func showRoute(response: MKDirectionsResponse) {
        
        for route in response.routes as! [MKRoute] {
            
            mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
            
            var realDistanceInt = Int(route.distance)
            self.setupTitleLabel()
            titleLabel.text = "\(realDistanceInt) meters to \(titleLabelText)"
            
            self.routeSteps = route.steps
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
        
        topLeftCoord.longitude = fmin(userLocation.coordinate.longitude, selectedPOI.coordinate.longitude)
        topLeftCoord.latitude = fmax(userLocation.coordinate.latitude, selectedPOI.coordinate.latitude)
        
        bottomRightCoord.longitude = fmax(userLocation.coordinate.longitude, selectedPOI.coordinate.longitude)
        bottomRightCoord.latitude = fmin(userLocation.coordinate.latitude, selectedPOI.coordinate.latitude)
        
        var region = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2
        
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 2
        } else {
            return 1
        }
    }
    
    @IBAction func wantToSee(sender: AnyObject) {
        
        if true == (sender as! UISwitch).on {
            currentManagedObject.setValue(true, forKey: "planned")
            self.saveManagedObjectContext()
        } else {
            currentManagedObject.setValue(false, forKey: "planned")
            self.saveManagedObjectContext()
        }
    }
    
    @IBAction func alreadySeen(sender: AnyObject) {
        
        if true == (sender as! UISwitch).on {
            wantSeeSwitch.on = false
            currentManagedObject.setValue(false, forKey: "planned")
            currentManagedObject.setValue(true, forKey: "seen")
            self.saveManagedObjectContext()
        } else {
            currentManagedObject.setValue(false, forKey: "seen")
            self.saveManagedObjectContext()
        }
    }
    
    func saveManagedObjectContext() {
        var error: NSError?
        managedObjectContext?.save(&error)
        
        if let err = error {
            println(err.localizedFailureReason)
        }
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFontOfSize(20.0)
    }
    
    func setBackgroundImage(image: UIImage, forView view: UIView) {
        self.view.backgroundColor = UIColor(patternImage: image)
        view.backgroundColor = UIColor(patternImage: image)
    }
}
