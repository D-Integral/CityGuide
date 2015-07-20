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

protocol RoutesReceiverDelegate {
    func routesReceived(routes: [String : MKRoute])
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
    var delegate: RoutesReceiverDelegate?
    
    func requestRoutesToPointsOfInterest() {
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
            let request = formedRequestFrom(location, toDestination: pointOfInterest.locationOnMap())
            let directions = MKDirections(request: request)
            calculate(directions, forPointOfInterest: pointOfInterest)
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
    
    func calculate(directions: MKDirections, forPointOfInterest pointOfInterest: PointOfInterest) {
        directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
            error != nil ? self.errorRequestRoute() : self.saveRouteFrom(response, forPointOfInterest: pointOfInterest)
        })
    }
    
    func errorRequestRoute() {
        println("Error getting directions!")
    }
    
    var count: Int = 0
    func saveRouteFrom(response: MKDirectionsResponse, forPointOfInterest pointOfInterest: PointOfInterest) {
        let route = response.routes[0] as! MKRoute
        
        routes.count != city.pointsInCity().count ? addRoute(route, forPointOfInterest: pointOfInterest) : delegate?.routesReceived(self.routes)
    }
    
    func addRoute(route: MKRoute, forPointOfInterest pointOfInterest: PointOfInterest) {
        routes[pointOfInterest.name] = route
        
        count++
        println("\(count). \(route.distance) for POI: \(pointOfInterest.name)")
    }
}

