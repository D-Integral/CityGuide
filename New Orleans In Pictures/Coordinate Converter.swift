//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 29.06.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import Foundation
import CoreLocation

class CoordinateConverter {
    
    struct Constants {
        static let shift: UInt64 = 30
        static let mask: UInt64 = 0b111111111111111111111111111111 //30 ones
        static let maxLongitude: CLLocationDegrees = 180.0
        static let maxLatitude: CLLocationDegrees = 85.0
    }
    
    init() {
        
    }

    //MARK: Packing algorithm
    
    /*
    func packCoordinate(coordinate: CLLocationCoordinate2D) -> UInt64 {
        return UInt64((coordinate.latitude + 85.0) * 1000000) << Constants.shift | UInt64((coordinate.longitude + 180.0) * 1000000)
    }*/

    func unpackCoordinate(packedCoordinate: UInt64) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(unpackLatitude(packedCoordinate), unpackLongitude(packedCoordinate))
    }

    func unpackLatitude(packedCoordinate: UInt64) -> CLLocationDegrees {
        let unpackedLatitude = CLLocationDegrees(Double(packedCoordinate >> Constants.shift) / 1000000) - Constants.maxLatitude
        return NSString(format: "%.6f", unpackedLatitude).doubleValue
    }

    func unpackLongitude(packedCoordinate: UInt64) -> CLLocationDegrees {
        let unpackedLongitude = CLLocationDegrees(Double(packedCoordinate & Constants.mask) / 1000000) - Constants.maxLongitude
        return NSString(format: "%.6f", unpackedLongitude).doubleValue
    }
}



