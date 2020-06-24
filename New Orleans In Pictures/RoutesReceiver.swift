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
    func routesReceived(_ routes: [String : MKRoute])
}

protocol RoutesReceiverFetchedRoute {
    func routeReceived(_ route: MKRoute, forPointOfInterest pointOfInterest: PointOfInterest)
}

class RoutesReceiver {
    
    static let sharedRoutesReceiver = RoutesReceiver()
    
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
    
    func convertToMKMapItem(_ location: CLLocation) -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
    }
    
    func removeAllRoutes() {
        routes = [String : MKRoute]()
    }
    
    func allRoutesReceived() -> Bool {
        return routes.count == city.pointsOfInterest.count ? true : false
    }
    
    func requestRouteTo(_ pointOfInterest: PointOfInterest) {
        
        if let location = userLocation {
            let request = formedRequestFrom(location, toDestination: pointOfInterest.locationOnMap())
            let directions = MKDirections(request: request)
            calculate(directions, toPointOfInterest: pointOfInterest)
            //print("Requested route to \(pointOfInterest.name)...")
        }
    }
    
    func formedRequestFrom(_ location: CLLocation, toDestination destination: CLLocation) -> MKDirections.Request {
        let request = MKDirections.Request()
        request.source = convertToMKMapItem(location)
        request.destination = convertToMKMapItem(destination)
        request.transportType = MKDirectionsTransportType.walking
        request.requestsAlternateRoutes = false
        
        return request
    }
    
    func calculate(_ directions: MKDirections, toPointOfInterest pointOfInterest: PointOfInterest) {
        
        directions.calculate(completionHandler: {(response: MKDirections.Response?, error: Error?) in
            error != nil ?  self.handleErrorResponse(pointOfInterest): self.handleSuccessResponse(response!, forPointOfInterest: pointOfInterest)
        })
    }
    
    func handleErrorResponse(_ pointOfInterest: PointOfInterest) {
        //print("Error getting directions for: \(pointOfInterest.name)")
    }
    
    func handleSuccessResponse(_ response: MKDirections.Response, forPointOfInterest pointOfInterest: PointOfInterest) {
        let route = response.routes[0]
        
        save(route, toPointOfInterest: pointOfInterest)
        delegateForRoute?.routeReceived(route, forPointOfInterest: pointOfInterest)
        //print("Received route for \(pointOfInterest.name): \(route.distance)")
    }
    
    func save(_ route: MKRoute, toPointOfInterest pointOfInterest: PointOfInterest) {
        routes.updateValue(route, forKey: pointOfInterest.name)
        
        if allRoutesReceived() { delegateForAllRoutes?.routesReceived(routes) }
    }
}

