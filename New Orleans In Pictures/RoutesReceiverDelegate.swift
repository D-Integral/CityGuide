//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import MapKit
import CityKit

extension GalleryVC {
    func routesReceived(_ routes: [String : MKRoute]) {
        routesToPointsOfInterest = routes
        sortItemsByRouteDistances()
        if navigationController?.visibleViewController == self {
            collectionView?.reloadData()
        }
    }
}

