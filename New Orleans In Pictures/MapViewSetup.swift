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
        mapView.frame.size.height = isCurrentDevicePadInLandscapeMode() ? heightForMapOnPadInLadscape() : self.tableView.frame.size.width
        mapView.frame.size.width = self.tableView.frame.size.width
    }
    
    func showSelectedSightAnnotation() {
        if let image = pointOfInterest.image() {
            let annotation = SightAnnotation(coordinate: pointOfInterest.coordinates.locationOnMap().coordinate, image: image)
            self.mapView.addAnnotation(annotation)
            
            pointOfInterestAnnotation = annotation
            
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is SightAnnotation) { return nil }
        
        let reuseId = "sight"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "sight")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView!.canShowCallout = false
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let sightAnnotation = annotation as! SightAnnotation
        
        annotationView!.image = sightAnnotation.image
        annotationView!.frame.size = CGSize(width: 150, height: 150)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.userLocation = userLocation
        
        showRouteInOptimalRegion()
    }
    
    func showRouteInOptimalRegion() {
        zoomToFitMapItems()
        showRoute()
        mapViewDidShowRoute = true
    }
    
    func showRoute() {
        let route = routeReceiver.routes[pointOfInterest.name]
        
        route != nil ? mapView.addOverlay(route!.polyline, level: MKOverlayLevel.aboveRoads) : routeReceiver.requestRouteTo(self.pointOfInterest)
    }
    
    func mapView(_ mapView: MKMapView,rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
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
    
    func setupRegionCenter(_ region: inout MKCoordinateRegion) {
        region.center.latitude = topLeftMapPoint().latitude - (topLeftMapPoint().latitude - bottomRightMapPoint().latitude) * 0.5
        region.center.longitude = topLeftMapPoint().longitude + (bottomRightMapPoint().longitude - topLeftMapPoint().longitude) * 0.5
    }
    
    func setupRegionSpan(_ region: inout MKCoordinateRegion) {
        region.span.latitudeDelta = fabs(topLeftMapPoint().latitude - bottomRightMapPoint().latitude) * 1.7
        region.span.longitudeDelta = fabs(bottomRightMapPoint().longitude - topLeftMapPoint().longitude) * 1.7
    }
    
    func removePreviousRouteFrom(_ mapView: MKMapView) {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
}

