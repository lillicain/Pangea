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
    static let items = CLLocationCoordinate2D(latitude: 37.0975, longitude: -113.5915)
    
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 37.0974, longitude: -113.5915)
    }
}

extension CLLocationCoordinate2D: Identifiable, Hashable, Equatable {
    public var id: Int {
        return hashValue
    }
    public func hash(into hasher: inout Hasher)  {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
    public static func <(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.longitude < rhs.longitude
    }
}


extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
    static let firstMapItem = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0976, longitude: -113.5991), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    static let secondMapItem = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.097654, longitude: -113.59915), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    static let thirdMapitem = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.097, longitude: -113.59911), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
}
