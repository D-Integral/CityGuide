//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 29.06.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import MapKit
import CoreLocation
import CityKit

class RouteDistanceCalculator {
    
    //MARK: public
    var distances: NSDictionary = [String : CLLocationDistance]()

    //MARK: private
    var city: City {
        return City.fetchCity() != nil ? City.fetchCity()! : City.createCityWithName("New Orleans")
    }
    
    var locationTracker: LocationTracker! {
        didSet {
           userLocation = convertCLLocationToMKMapItem(locationTracker.currentLocation!)
        }
    }
    
    var userLocation: MKMapItem!
    var destination: MKMapItem!
    
    init(locationTracker: LocationTracker) {
        self.locationTracker = locationTracker
    }
    
    //MARK: public
    
    func distancetoPointOfInterest(pointOfInterest: PointOfInterest) -> CLLocationDistance {
        var distance: CLLocationDistance!
        
        let directions = queryDirectionsToPointOfInterest(pointOfInterest)
        directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
            distance = error != nil ? self.errorRequestDirections() : self.successRequestDirections(response)
        })
        
        return distance
    }
    
    //MARK: private
    
    func convertCLLocationToMKMapItem(location: CLLocation) -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
    }
    
    func queryDirectionsToPointOfInterest (pointOFInterest: PointOfInterest) -> MKDirections {
        let request = MKDirectionsRequest()
        request.setSource(userLocation)
        request.setDestination(convertCLLocationToMKMapItem(pointOFInterest.locationOnMap()))
        request.requestsAlternateRoutes = false
        
        return MKDirections(request: request)
    }
    
    
    func errorRequestDirections() -> CLLocationDistance {
        println("Error getting directions")
        return CLLocationDistance()
    }
    
    func successRequestDirections(response: MKDirectionsResponse) -> CLLocationDistance {
        var distance: CLLocationDistance!
        
        for route in response.routes as! [MKRoute] {
            distance = route.distance
        }
        
        return distance
    }

    
//    func getDirectionsToPointOfInterest(pointOfInterestLocation: CLLocationCoordinate2D) {
//        
//        let request = MKDirectionsRequest()
//        request.setSource(MKMapItem.mapItemForCurrentLocation())
//        request.setDestination(destination(pointOfInterestLocation))
//        request.requestsAlternateRoutes = false
//        
//        let directions = MKDirections(request: request)
//        
//        directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
//            if error != nil {
//                println("Error getting directions")
//            } else {
//                //self.showRoute(response)
//                self.response = response
//            }
//        })
//    }
//    
//    func routeDistance(response: MKDirectionsResponse) -> CLLocationDistance {
//        var distance: CLLocationDistance!
//                
//        for route in response.routes as! [MKRoute] {
//            distance = route.distance
//        }
//                
//        return distance
//    }
}
