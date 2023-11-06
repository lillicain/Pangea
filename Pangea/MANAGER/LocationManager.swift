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

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    var locationManager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.094, longitude: -113.5915), latitudinalMeters: 10000, longitudinalMeters: 10000)
    
    @Published var authorizationState: CLAuthorizationStatus?
    @Published var placemark: CLPlacemark?
    @Published var heading: CLHeading?
    @Published var location: CLLocation?
    @Published var currentLocation: String = ""
    @Published var geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func geocode() {
        guard let location = self.location else { return }
        geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
            if error == nil {
                self.placemark = places?[0]
            } else {
                self.placemark = nil
            }
        })
    }
    
//    @MainActor
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        self.location = location
        self.geocode()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            self.placemark = placemarks?.last
        }
        
        fetchCurrentLocation { placemark in
            self.currentLocation = placemark ?? ""
        }
        
// DispatchQueue.main.async { }
        
        self.region = region
        print(location.description)
        print(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func fetchCurrentLocation(completionHandler: @escaping (String?) -> Void) {
        if let lastLocation = locationManager.location {
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
    
    func fetchLocation(addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                    print("Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            } else {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                    print("Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined: locationManager.requestAlwaysAuthorization()
        case .restricted: print("Change Settings")
        case .denied: print("Change Settings")
        case .authorizedAlways, .authorizedWhenInUse: break
            
        @unknown default: break
            
        }
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            checkLocationAuthorization()
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
        } else {
            print("Alert")
        }
    }
}

