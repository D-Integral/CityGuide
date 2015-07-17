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
    
    var locationTracker: LocationTracker!

    func routeDistancesToPointsOfInterestInCity(city: City) -> [String : CLLocationDistance] {
        var returnDistances = [String : CLLocationDistance]()
        
        for pointOfInterest in city.pointsInCity() {
            returnDistances[pointOfInterest.name] = routeDistanceTo(pointOfInterest)
        }
        
        return returnDistances
    }
    
    //MARK: private
    
    func convertToMKMapItem(location: CLLocation) -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
    }
    
    func routeDistanceTo(pointOfInterest: PointOfInterest) -> CLLocationDistance {
        
        var distance = CLLocationDistance()
        
        if let userLocation = locationTracker.currentLocation {
            let request = MKDirectionsRequest()
            request.setSource(convertToMKMapItem(userLocation))
            request.setDestination(convertToMKMapItem(pointOfInterest.locationOnMap()))
            request.requestsAlternateRoutes = false
        
            let directions = MKDirections(request: request)

            directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
                distance = error != nil ? self.errorRequestDirections() : self.successRequestDirections(response)
            })
        }
        
        return distance
    }
    
    func errorRequestDirections() -> CLLocationDistance {
        println("Error getting directions!")
        return CLLocationDistance()
    }
        
    func successRequestDirections(response: MKDirectionsResponse) -> CLLocationDistance {
        var distance: CLLocationDistance!
        
        for route in response.routes as! [MKRoute] {
            distance = route.distance
        }
                
        return distance
    }
}
