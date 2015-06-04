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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var wantSeeSwitch: UISwitch!
    @IBOutlet weak var seenSwitch: UISwitch!
    
    
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
        
        self.receiveDataFromGalleryVC()
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
    
    func receiveDataFromGalleryVC() {
        
        imageView.image = self.image
        titleLabel.text = self.titleLabelText
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
        
        selectedPOI = CLLocation(latitude: latitude, longitude: longitude)
        
        var placemark = MKPlacemark(coordinate: coords, addressDictionary: nil)
        destination = MKMapItem(placemark: placemark)
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        mapView.centerCoordinate = userLocation.location.coordinate
        
        self.userLocation = userLocation
        self.zoomToFitMapItems()
        self.getDirections()
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if !(annotation is SightAnnotation) {
            return nil
        }
        
        let reuseId = "sight"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("sight")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        else {
            annotationView.annotation = annotation
        }
        
        let sightAnnotation = annotation as! SightAnnotation
        annotationView.image = sightAnnotation.image
        annotationView.frame.size.width = 100.0
        annotationView.frame.size.height = 100.0
        
        return annotationView
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
        
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.3
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.3
        
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 2
        } else {
            return 1
        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        self.performSegueWithIdentifier("toSteps", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toSteps" {
            var destinationVC = segue.destinationViewController as! StepsViewController
            destinationVC.steps = self.routeSteps
        }
    }
    
    @IBAction func toStepsVC(sender: AnyObject) {
        self.performSegueWithIdentifier("toSteps", sender: self)
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
}
