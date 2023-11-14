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
    static var schoolLocation: CLLocationCoordinate2D {
        return .init(latitude: 37.098473, longitude: -113.591548)
    }
    static var homeLocation: CLLocationCoordinate2D {
        return .init(latitude: 37.1349, longitude: -113.38032)
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

extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}

extension MKCoordinateRegion {
    
    static var userRegion: MKCoordinateRegion {
        return MKCoordinateRegion()
    }
    
    static let firstMapItem = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0976, longitude: -113.591), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    static let secondMapItem = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0974, longitude: -113.591), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    static let thirdMapitem = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.09745, longitude: -113.5914), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
}

