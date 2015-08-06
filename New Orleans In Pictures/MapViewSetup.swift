//
//  MapViewSetup.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import MapKit

extension TableViewController {
    func mapViewSetup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.frame.size.height = self.tableView.frame.size.width
        mapView.frame.size.width = self.tableView.frame.size.width
    }
    
    func showSelectedSightAnnotation() {
    
        let annotation = SightAnnotation(coordinate: pointOfInterest.coordinates.locationOnMap().coordinate, image: image)
        self.mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 4000, 4000)
        mapView.setRegion(region, animated: true)
        
        self.setupDistanceLabel()
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is SightAnnotation) { return nil }
        
        let reuseId = "sight"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("sight")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView.canShowCallout = false
        }
        else {
            annotationView.annotation = annotation
        }
        
        let sightAnnotation = annotation as! SightAnnotation
        
        annotationView.image = sightAnnotation.image
        annotationView.frame.size.width = 60.0
        annotationView.frame.size.height = 60.0
        
        println("Frame for annotation view: \(annotationView.frame)")
        println("Center offset: \(annotationView.center)")
        println("Center offset: \(annotationView.centerOffset)")
        
        return annotationView
    }
    
    func setupDistanceLabel() {
        distanceLabel.font = UIFont.boldSystemFontOfSize(20.0)
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        self.userLocation = userLocation
        isUserInTheCity() ? showRouteInOptimalRegion() : showSelectedSightAnnotation()
    }
    
    func showRouteInOptimalRegion() {
        zoomToFitMapItems()
        showRoute()
    }
    
    func showRoute() {
        if routeToPointOfInterest != nil {
            mapView.addOverlay(routeToPointOfInterest.polyline, level: MKOverlayLevel.AboveRoads)
            addDistanceToDistanceLabel(routeToPointOfInterest.distance)
        }
    }
    
    func isUserInTheCity() -> Bool {
        let userLongitude = userLocation.location.coordinate.longitude
        let userLatitude = userLocation.location.coordinate.latitude
        
        return (userLongitude < Constants.cityEdges["right"] && userLongitude > Constants.cityEdges["left"] && userLatitude < Constants.cityEdges["top"] && userLatitude > Constants.cityEdges["bottom"]) ? true : false
    }
    
    func addDistanceToDistanceLabel(distance: CLLocationDistance) {
        self.distanceLabel.alpha = 0.0
        self.distanceLabel.text = "\(DistanceFormatter.formatted(distance))"
        
        UIView.animateWithDuration(1, animations: {
            self.distanceLabel.alpha = 1.0
            }, completion: nil)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blueColor()
        renderer.lineWidth = 7.0
        
        return renderer
    }
    
    func zoomToFitMapItems() {
        self.imageView.removeFromSuperview()
        
        var region = MKCoordinateRegion()
        setupRegionCenter(&region)
        setupRegionSpan(&region)
        
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }
    
    func topLeftMapPoint() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: fmax(userLocation.coordinate.latitude, pointOfInterest.coordinates.latitude.doubleValue), longitude: fmin(userLocation.coordinate.longitude, pointOfInterest.coordinates.longitude.doubleValue))
    }
    
    func bottomRightMapPoint() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: fmin(userLocation.coordinate.latitude, pointOfInterest.coordinates.latitude.doubleValue), longitude: fmax(userLocation.coordinate.longitude, pointOfInterest.coordinates.longitude.doubleValue))
    }
    
    func setupRegionCenter(inout region: MKCoordinateRegion) {
        region.center.latitude = topLeftMapPoint().latitude - (topLeftMapPoint().latitude - bottomRightMapPoint().latitude) * 0.5
        region.center.longitude = topLeftMapPoint().longitude + (bottomRightMapPoint().longitude - topLeftMapPoint().longitude) * 0.5
    }
    
    func setupRegionSpan(inout region: MKCoordinateRegion) {
        region.span.latitudeDelta = fabs(topLeftMapPoint().latitude - bottomRightMapPoint().latitude) * 1.2
        region.span.longitudeDelta = fabs(bottomRightMapPoint().longitude - topLeftMapPoint().longitude) * 1.2
    }
}

