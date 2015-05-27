//
//  DetailVC.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 25.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailVC: UIViewController, UINavigationControllerDelegate, MKMapViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenCellIndexPath: NSIndexPath!
    
    var image: UIImage = UIImage()
    var titleLabelText = String()
    
    var selectedPOI: CLLocation = CLLocation()
    var userLocation: MKUserLocation!

    var destination: MKMapItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = self.image
        titleLabel.text = self.titleLabelText
        
        self.mapViewSetup()
        self.showSelectedSightAnnotation()
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
        annotationView.frame.size.width = 60.0
        annotationView.frame.size.height = 60.0
        
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
            distanceLabel.text = "\(realDistanceInt) meters to \(titleLabelText)"
            
            for step in route.steps {
                println(step.instructions)
            }
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
        
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1
        
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }
}
