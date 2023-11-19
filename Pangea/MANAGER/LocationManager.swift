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

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @Published var post: Post
    @Published var posts = [Post]()
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.094, longitude: -113.5915), latitudinalMeters: 10000, longitudinalMeters: 10000)
    
    @Published var authorizationState: CLAuthorizationStatus?
    @Published var placemark: CLPlacemark?
    @Published var location: CLLocation?
    
    @Published var currentLocation: String = ""
    @Published var item: CLLocationCoordinate2D?
    
    @Published var postImages = CLLocationCoordinate2D()
    
    @Published var coordinates: (Double, Double) = (0.0, 0.0)
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    override init() {
        self.post = Post.MOCK_POST[0]
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
    
    @MainActor
    func fetchPosts(post: Post) async {
        let geocoder = CLGeocoder()
        
        Task {
            do {
                let coordinate = try await getCoordinateAsync(geocoder: geocoder, addressString: post.location)
                coordinates = (coordinate.latitude, coordinate.longitude)
                print("Coordinates: \(coordinates.0), \(coordinates.1)")
            } catch {
                print(error.localizedDescription)
            }
        }
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        self.item = location.coordinate
       
        self.region = region
        
        self.geocode()
        
        print(location.description)
        print(location.coordinate)
        
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            self.placemark = placemark?[0]
        }
        
        fetchCurrentLocation { placemark in
            self.currentLocation = placemark ?? ""
        }
        
        fetchLocation(address: post.location) { placemark, error in
            self.postImages = placemark
            
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
    
    func getCoordinate(addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
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
    
    
    func fetchCurrentLocation(completionHandler: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        
        if let location = locationManager.location {
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error == nil {
                    let locationName = placemarks?[0].name
                    completionHandler(locationName)
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
            print("Alert")
        }
    }
}

