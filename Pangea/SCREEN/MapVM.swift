//
//  MapVM.swift
//  Pangea
//
//  Created by Lillian Cain on 10/25/23.
//

import Foundation
import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI
import Firebase
import FirebaseFirestore

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    private static let locationDistance: CLLocationDistance = 10000
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.094, longitude: -113.5915), latitudinalMeters: LocationManager.locationDistance, longitudinalMeters: LocationManager.locationDistance)
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    override init() {
        super.init()
        manager.activityType = .automotiveNavigation
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        guard let uid = self.authenticationViewModel.userSession?.uid else { return }
        
        
        if let userLocation = locations.last {
            let userLatitude = location.coordinate.latitude
            let userLongitude = location.coordinate.longitude
            
            
        }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: Self.locationDistance, longitudinalMeters: Self.locationDistance)
//            let last = locations.last
//            Firestore.firestore().collection("locations").document("sharing").setData(["updates" : [uid : GeoPoint(latitude: (last?.coordinate.latitude)!, longitude: (last?.coordinate.longitude)!)]]) { (err) in
//                if err != nil {
//                    print((err?.localizedDescription)!)
//                    return
//                }
//            }
        }
        
        
        
        print("\(location)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
