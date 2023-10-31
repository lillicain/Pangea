//
//  MapExtensions.swift
//  Pangea
//
//  Created by Lillian Cain on 10/23/23.
//

import Foundation
import MapKit
import CoreLocation
import CoreLocationUI

extension CLLocationCoordinate2D {
    
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 37.0974, longitude: -113.5915)
    }
    
    static let myMarker = CLLocationCoordinate2D(latitude: 37.0974, longitude: -113.5915)
}

//extension CLLocationCoordinate2D: Identifiable, Hashable, Equatable {
//    public var id: Int {
//        return hashValue
//    }
//    public func hash(into hasher: inout Hasher)  {
//        hasher.combine(latitude)
//        hasher.combine(longitude)
//    }
//    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
//    }
//    public static func <(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//        return lhs.longitude < rhs.longitude
//    }
//}

extension MKCoordinateRegion {
    
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
    
    static let firstMapItem = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.09745, longitude: -113.591), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    static let secondMapItem = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.09751, longitude: -113.5915), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    static let thirdMapItem = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0944, longitude: -113.5911), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
}
