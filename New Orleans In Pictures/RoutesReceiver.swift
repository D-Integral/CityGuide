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

protocol RoutesReceiverFetchedAllRoutesDelegate {
    func routesReceived(routes: [String : MKRoute])
}

protocol RoutesReceiverFetchedRoute {
    func routeReceived(route: MKRoute, forPointOfInterest pointOfInterest: PointOfInterest)
}

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
    var city: City!
    var userLocation: CLLocation!
    var delegateForAllRoutes: RoutesReceiverFetchedAllRoutesDelegate?
    var delegateForRoute: RoutesReceiverFetchedRoute?
    
    func requestRoutesToPointsOfInterest() {
        for pointOfInterest in city.pointsInCity() {
            requestRouteTo(pointOfInterest)
        }
    }
    
    //MARK: private
    
    func convertToMKMapItem(location: CLLocation) -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
    }
    
    func removeAllRoutes() {
        routes = [String : MKRoute]()
    }
    
    func allRoutesReceived() -> Bool {
        return routes.count == city.pointsInCity().count ? true : false
    }
    
    func requestRouteTo(pointOfInterest: PointOfInterest) {
        
        if let location = userLocation {
            let request = formedRequestFrom(location, toDestination: pointOfInterest.locationOnMap())
            let directions = MKDirections(request: request)
            calculate(directions, toPointOfInterest: pointOfInterest)
            println("Requested route to \(pointOfInterest.name)...")
        }
    }
    
    func formedRequestFrom(location: CLLocation, toDestination destination: CLLocation) -> MKDirectionsRequest {
        let request = MKDirectionsRequest()
        request.setSource(convertToMKMapItem(location))
        request.setDestination(convertToMKMapItem(destination))
        request.transportType = MKDirectionsTransportType.Walking
        request.requestsAlternateRoutes = false
        
        return request
    }
    
    func calculate(directions: MKDirections, toPointOfInterest pointOfInterest: PointOfInterest) {
        directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
            error != nil ?  self.handleErrorResponse(pointOfInterest): self.handleSuccessResponse(response, forPointOfInterest: pointOfInterest)
        })
    }
    
    func handleErrorResponse(pointOfInterest: PointOfInterest) {
        println("Error getting directions for: \(pointOfInterest.name)")
    }
    
    func handleSuccessResponse(response: MKDirectionsResponse, forPointOfInterest pointOfInterest: PointOfInterest) {
        let route = response.routes[0] as! MKRoute
        
        save(route, toPointOfInterest: pointOfInterest)
        delegateForRoute?.routeReceived(route, forPointOfInterest: pointOfInterest)
        println("Received route for \(pointOfInterest.name): \(route.distance)")
    }
    
    func save(route: MKRoute, toPointOfInterest pointOfInterest: PointOfInterest) {
        routes[pointOfInterest.name] = route
        
        if allRoutesReceived() { delegateForAllRoutes?.routesReceived(routes) }
    }
}

