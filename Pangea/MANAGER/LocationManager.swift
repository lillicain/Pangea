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
import UIKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
//    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0974, longitude: -113.5915), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.094, longitude: -113.5915), latitudinalMeters: 10000, longitudinalMeters: 10000)
    
    @Published var authorizationState: CLAuthorizationStatus?
    @Published var placemark: CLPlacemark?
    @Published var heading: CLHeading?
    @Published var location: CLLocation?
    @Published var currentLocation: String?
    @Published var userLocation: CLLocation?
    
    
    @ObservedObject var authenticationViewModel = AuthenticationViewModel.shared
    private let geocoder = CLGeocoder()
    
    override init() {
        super.init()
        manager.activityType = .automotiveNavigation
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    private func geocode() {
       guard let location = self.location else { return }
       geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
         if error == nil {
           self.placemark = places?[0]
         } else {
           self.placemark = nil
         }
       })
     }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
        self.geocode()
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            self.placemark = placemarks?.last
        }
        
        
        lookUpCurrentLocation { placemark in
            self.currentLocation = placemark
        }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            
        }
        print(location.description)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
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
    
    func getCoordinate(addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                           print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationState = manager.authorizationStatus
        
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            
        } else if manager.authorizationStatus == .denied {
            manager.startUpdatingLocation()
        }
    }
}

//final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager?
//    
//    func checkIfLocationServicesIsEnabled() {
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager = CLLocationManager()
//            checkLocationAuthorization()
//            
//            locationManager = CLLocationManager()
//            locationManager!.delegate = self
//        } else {
//            print("Alert")
//        }
//    }
//    
//   private func checkLocationAuthorization() {
//        guard let locationManager = locationManager else { return }
//        
//        switch locationManager.authorizationStatus {
//            
//        case .notDetermined: locationManager.requestAlwaysAuthorization()
//        case .restricted: print("Go to settings")
//        case .denied: print("Go to settings")
//        case .authorizedAlways, .authorizedWhenInUse: break
//            
//        @unknown default:
//            break
//        }
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationAuthorization()
//    }
//}
