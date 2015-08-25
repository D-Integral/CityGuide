//
//  MapViewSetup.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import MapKit

extension DetailViewController {
    func mapViewSetup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.frame.size.height = self.tableView.frame.size.width
        mapView.frame.size.width = self.tableView.frame.size.width
    }
    
    func showSelectedSightAnnotation() {
    
        let annotation = SightAnnotation(coordinate: pointOfInterest.coordinates.locationOnMap().coordinate, image: image)
        self.mapView.addAnnotation(annotation)
        
        pointOfInterestAnnotation = annotation
        
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 4000, 4000)
        mapView.setRegion(region, animated: true)
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
        annotationView.frame.size = CGSizeMake(150, 150)
     
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        removePreviousRouteFrom(mapView)
        self.userLocation = userLocation
        showRouteInOptimalRegion()
    }
    
    func showRouteInOptimalRegion() {
        zoomToFitMapItems()
        showRoute()
    }
    
    func showRoute() {
        let route = locationDataVC.routesReceiver.routes[pointOfInterest.name]
        if route != nil {
            mapView.addOverlay(route!.polyline, level: MKOverlayLevel.AboveRoads)
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blueColor()
        renderer.lineWidth = 7.0
        
        return renderer
    }
    
    func zoomToFitMapItems() {
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
        region.span.latitudeDelta = fabs(topLeftMapPoint().latitude - bottomRightMapPoint().latitude) * 1.7
        region.span.longitudeDelta = fabs(bottomRightMapPoint().longitude - topLeftMapPoint().longitude) * 1.7
    }
    
    func removePreviousRouteFrom(mapView: MKMapView) {
        let overlays = mapView.overlays as? [MKOverlay]
        mapView.removeOverlays(overlays)
    }
}

