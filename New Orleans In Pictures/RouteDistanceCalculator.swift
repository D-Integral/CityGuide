//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 29.06.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import MapKit
import CoreLocation
import CityKit

class RouteDistanceCalculator {
    
    //MARK: public
    
    class var sharedRouteDistanceCalculator: RouteDistanceCalculator {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: RouteDistanceCalculator? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = RouteDistanceCalculator()
        }
        return Static.instance!
    }
    
    var routeDistances = [String : CLLocationDistance]()
    
    var locationTracker: LocationTracker!
    
    func requestRouteDistancesToPointsOfInterestInCity(city: City) {
        for pointOfInterest in city.pointsInCity() {
            requestRouteDistanceTo(pointOfInterest)
        }
    }
    
    //MARK: private
    
    func convertToMKMapItem(location: CLLocation) -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
    }
    
    func requestRouteDistanceTo(pointOfInterest: PointOfInterest) {
        
        if let userLocation = locationTracker.currentLocation {
            
            let request = MKDirectionsRequest()
            request.setSource(convertToMKMapItem(userLocation))
            
            //println("UserLocation.latitude: \(convertToMKMapItem(userLocation).placemark.coordinate.latitude)\n UserLocation.longitude: \(convertToMKMapItem(userLocation).placemark.coordinate.longitude)\n")
            
            request.setDestination(convertToMKMapItem(pointOfInterest.locationOnMap()))
            
            //println("Destination.latitude: \(convertToMKMapItem(pointOfInterest.locationOnMap()).placemark.coordinate.latitude)\n Destination.longitude: \(convertToMKMapItem(pointOfInterest.locationOnMap()).placemark.coordinate.longitude)\n")
            
            request.transportType = MKDirectionsTransportType.Automobile
            request.requestsAlternateRoutes = false
            
            
            let directions = MKDirections(request: request)
            
            directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
                error != nil ? self.errorRequestDirections() : self.successRequestDirections(response, forPointOfInterest: pointOfInterest)
            })
        }
    }
    
    func errorRequestDirections() {
        println("Error getting directions!")
    }
    
    func successRequestDirections(response: MKDirectionsResponse, forPointOfInterest pointOfInterest: PointOfInterest) {
        let route = response.routes[0] as! MKRoute
        
        if routeDistances.count < 25 {
            routeDistances[pointOfInterest.name] = route.distance
        
            //println("\(numberSuccess).\(routeDistances[pointOfInterest.name])")
        }
    }
}
