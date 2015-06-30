//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 29.06.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import MapKit
import CoreLocation

class RouteDistanceCalculator {
    
    var response: MKDirectionsResponse!
    
    var locationTracker: LocationTracker!
    
    var distances: NSDictionary = [String : CLLocationDistance]()
    
    init(locationTracker: LocationTracker) {
        self.locationTracker = locationTracker
    }
    
    func routeDistanceToPointOfInterestWithCoordinate(pointOfInterestLocation: CLLocationCoordinate2D) -> CLLocationDistance {
        var distance: CLLocationDistance!
        
        getDirectionsToPointOfInterest(pointOfInterestLocation)
        distance = routeDistance(response)
        
        return distance
    }
        
    func getDirectionsToPointOfInterest(pointOfInterestLocation: CLLocationCoordinate2D) {
        
        let request = MKDirectionsRequest()
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        request.setDestination(destination(pointOfInterestLocation))
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
            if error != nil {
                println("Error getting directions")
            } else {
                //self.showRoute(response)
                self.response = response
            }
        })
    }
        
    func destination(location: CLLocationCoordinate2D) -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(coordinate: location, addressDictionary: nil))
    }
        
    func routeDistance(response: MKDirectionsResponse) -> CLLocationDistance {
        var distance: CLLocationDistance!
                
        for route in response.routes as! [MKRoute] {
            distance = route.distance
        }
                
        return distance
    }
}
