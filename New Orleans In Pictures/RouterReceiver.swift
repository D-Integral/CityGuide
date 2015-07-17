//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 17.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import MapKit
import CoreLocation
import CityKit

class RoutesReceiver {
    
    //MARK: public
    
    class var sharedRoutesReceiver: RoutesReceiver {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: RoutesReceiver? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = RoutesReceiver()
        }
        return Static.instance!
    }
    
    var routes = [String : MKRoute]()
    
    var userLocation: CLLocation!
    
    func requestRoutesToPointsOfInterestInCity(city: City) {
        for pointOfInterest in city.pointsInCity() {
            requestRouteTo(pointOfInterest)
        }
    }
    
    //MARK: private
    
    func convertToMKMapItem(location: CLLocation) -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
    }
    
    func requestRouteTo(pointOfInterest: PointOfInterest) {
        
        if let location = userLocation {
            
            let request = MKDirectionsRequest()
            request.setSource(convertToMKMapItem(location))
            request.setDestination(convertToMKMapItem(pointOfInterest.locationOnMap()))
            request.transportType = MKDirectionsTransportType.Walking
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
        
        if routes.count < 25 {
            routes[pointOfInterest.name] = route
        }
    }
}

