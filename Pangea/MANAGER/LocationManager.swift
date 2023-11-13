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
import UIKit
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    let post: Post
    
    @Published var posts = [Post]()
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.094, longitude: -113.5915), latitudinalMeters: 10000, longitudinalMeters: 10000)
    @Published var authorizationState: CLAuthorizationStatus?
    @Published var placemark: CLPlacemark?
    @Published var heading: CLHeading?
    @Published var location: CLLocation?
    @Published var currentLocation: String = ""
    @Published var postLocation = CLLocationCoordinate2D()
    @Published var item: CLLocationCoordinate2D?
    @Published var coordinates: CLLocationCoordinate2D?
    @Published var postAnnotation = MKPointAnnotation()
    
    override init() {
        self.post = Post.MOCK_POST[0]
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        self.location = location
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
        
        getLocation { newPost in
            self.coordinates = newPost
          
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    private func getCoordinate(addressString : String,
                               completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
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
                    let locationCoordinates = placemarks?[0].location
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
    
    func getLocation(completionHandler: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        if let newPost = post?.location {
            geocoder.geocodeAddressString(newPost, completionHandler: { (placemarks, error) in
                if error == nil {
                    let locationCoordinates = placemarks?[0].location
                    completionHandler(locationCoordinates?.coordinate)
                    
                } else {
                    completionHandler(nil)
                }
            })
        } else {
            completionHandler(nil)
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

