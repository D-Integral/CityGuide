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
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenCellIndexPath: NSIndexPath!
    var image: UIImage = UIImage()
    var titleLabelText = String()
    
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
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        mapView.centerCoordinate = userLocation.location.coordinate
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
