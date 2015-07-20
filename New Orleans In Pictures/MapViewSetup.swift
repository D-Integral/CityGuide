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
        isUserInTheCity() ? showRouteInOptimalRegion() : showSelectedSightAnnotation()
    }
    
    func showRouteInOptimalRegion() {
        zoomToFitMapItems()
        showRoute()
    }
    
    func showRoute() {
        if routeToPointOfInterest != nil {
            mapView.addOverlay(routeToPointOfInterest.polyline, level: MKOverlayLevel.AboveRoads)
            addDistanceToTitleLabel(routeToPointOfInterest.distance)
        }
    }
    
    func isUserInTheCity() -> Bool {
        let userLongitude = userLocation.location.coordinate.longitude
        let userLatitude = userLocation.location.coordinate.latitude
        
        return (userLongitude < Constants.cityEdges["right"] && userLongitude > Constants.cityEdges["left"] && userLatitude < Constants.cityEdges["top"] && userLatitude > Constants.cityEdges["bottom"]) ? true : false
    }
    
    func addDistanceToTitleLabel(distance: CLLocationDistance) {
        self.titleLabel.alpha = 0.0
        self.titleLabel.text = self.pointOfInterest.name + " : \(DistanceFormatter.formatted(distance))"
        
        UIView.animateWithDuration(1, animations: {
            self.titleLabel.alpha = 1.0
            }, completion: nil)
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
        region.span.latitudeDelta = fabs(topLeftMapPoint().latitude - bottomRightMapPoint().latitude) * 1.2
        region.span.longitudeDelta = fabs(bottomRightMapPoint().longitude - topLeftMapPoint().longitude) * 1.2
    }
}

