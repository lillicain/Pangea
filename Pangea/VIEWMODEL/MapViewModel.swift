//
//  MapViewModel.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import Foundation
import UIKit
import SwiftUI
import MapKit
import CoreLocationUI
import CoreLocation
import Firebase

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var place: String?
    
    let manager = CLLocationManager()
   
    override init() {
        super.init()
        manager.delegate = self
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lookUpCurrentLocation { placemark in
            self.place = placemark
        }
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (String?) -> Void) {
        if let lastLocation = manager.location {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                
                if error == nil {
                    let firstLocation = placemarks?[0].name
                    completionHandler(firstLocation)
                } else {
                    completionHandler(nil)
                }
            })
        } else {
            completionHandler(nil)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func requestAllowOnceLocationPermission() {
        manager.requestAlwaysAuthorization()
    }
    
    func requestUserAuthorization() async throws {
        manager.requestWhenInUseAuthorization()
    }
    
    func startCurrentLocationUpdates() async throws {
        for try await locationUpdate in CLLocationUpdate.liveUpdates() {
            guard let _ = locationUpdate.location else { return }
            
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
}
