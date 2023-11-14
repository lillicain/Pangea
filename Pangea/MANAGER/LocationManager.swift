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
import FirebaseFirestoreSwift

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @Published var post: Post? = nil
    @Published var posts = [Post]()
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.094, longitude: -113.5915), latitudinalMeters: 10000, longitudinalMeters: 10000)
    @Published var authorizationState: CLAuthorizationStatus?
    @Published var placemark: CLPlacemark?
    @Published var location: CLLocation?
    @Published var currentLocation: String = ""
    @Published var item1: CLLocationCoordinate2D?
    @Published var item2: CLLocationCoordinate2D?
    @Published var item3: CLLocationCoordinate2D?
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func geocode() {
        guard let location = location else { return }
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemark, error) in
                if error == nil {
                    self.placemark = placemark?[0]
                } else {
                    self.placemark = nil
                }
            })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        self.region = region
        self.item1 = location.coordinate
        self.item2 = .homeLocation
        self.item3 = locations.first?.coordinate
        
        self.geocode()
        
        print(location.description)
        print(location.coordinate)
        
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            self.placemark = placemark?[0]
        }
        
        fetchCurrentLocation { placemark in
            self.currentLocation = placemark ?? ""
        }
    }
    
    func getCoordinateAsync(geocoder: CLGeocoder, addressString: String) async throws -> CLLocationCoordinate2D {
        return try await withCheckedThrowingContinuation { continuation in
            geocoder.geocodeAddressString(addressString) { (placemarks, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let placemark = placemarks?.first {
                    let coordinate = placemark.location?.coordinate ?? kCLLocationCoordinate2DInvalid
                    continuation.resume(returning: coordinate)
                } else {
                    continuation.resume(returning: kCLLocationCoordinate2DInvalid)
                }
            }
        }
    }
    
    private func getCoordinate(addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func fetchCurrentAddress(completionHandler: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        
        if let location = locationManager.location {
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error == nil {
                    let locationName = placemarks?[0].name
                    completionHandler(locationName)
                } else {
                    completionHandler(nil)
                }
            })
        } else {
            completionHandler(nil)
        }
    }
    
    
    func fetchCurrentLocation(completionHandler: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        
        if let location = locationManager.location {
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error == nil {
                    let locationName = placemarks?[0].name
                    completionHandler(locationName)
                } else {
                    completionHandler(nil)
                }
            })
        } else {
            completionHandler(nil)
        }
    }
    
    func fetchLocation(address: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let postLocation: CLLocationCoordinate2D = placemark.location!.coordinate
                    print("Latitude: \(postLocation.latitude), Longitude: \(postLocation.longitude)")
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
    
    func checkLocationAuthorization() {
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
            locationManager.delegate = self
            
            checkLocationAuthorization()
        } else {
            print("Allow Location")
        }
    }
}

