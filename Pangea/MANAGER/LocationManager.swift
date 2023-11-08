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

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    var locationManager = CLLocationManager()
    var post: Post = Post.MOCK_POST[0]
    
    @Published var geocoder = CLGeocoder()
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.094, longitude: -113.5915), latitudinalMeters: 10000, longitudinalMeters: 10000)
    @Published var authorizationState: CLAuthorizationStatus?
    @Published var placemark: CLPlacemark?
    @Published var heading: CLHeading?
    @Published var location: CLLocation?
    
    @Published var currentLocation: String = ""
    @Published var otherPlacemark: MKPlacemark?

    
    @Published var item: CLLocationCoordinate2D?
    
//    @Published private(set) var annotationItems: [AnnotationItem] = []
  
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        
    }
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        <#code#>
//    }
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
        
        
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            self.placemark = placemark?.last
            
        }
        
        fetchCurrentLocation { placemark in
            self.currentLocation = placemark ?? ""
        }
        
        getLocation(from: post.location) { post in
            self.item = post
        }
        
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
    
    func fetchLocation(address: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void) {
     
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
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
            let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
    
    
//    func getPlace(from address: String) {
//            let request = MKLocalSearch.Request()
//            let title = "" //address.title
//            let subTitle = "" // addubtitleress.s
//
//            request.naturalLanguageQuery = subTitle.contains(title)
//            ? subTitle : title + ", " + subTitle
//
//            Task {
//                let response = try await MKLocalSearch(request: request).start()
//                await MainActor.run {
//                    self.annotationItems = response.mapItems.map {
//                        AnnotationItem(
//                            latitude: $0.placemark.coordinate.latitude,
//                            longitude: $0.placemark.coordinate.longitude
//                        )
//                    }
//
//                    self.region = response.boundingRegion
////                }
////            }
////        }
////    }
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//            guard let newLocation = userLocation.location else { return }
//            
//            let currentTime = Date()
//            let lastLocation = self.currentLocation
//            self.currentLocation = currentLocation
//            
//            // Only get new placemark information if you don't have a previous location,
//            // if the user has moved a meaningful distance from the previous location, such as 1000 meters,
//            // and if it's been 60 seconds since the last geocode request.
//        if let lastLocation = currentLocation {
//                newLocation.distance(from: lastLocation) <= 1000,
//                let lastTime = lastGeocodeTime,
//                currentTime.timeIntervalSince(lastTime) < 60 {
//                return
//            }
//            
//            // Convert the user's location to a user-friendly place name by reverse geocoding the location.
//            lastGeocodeTime = currentTime
//            geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
//                guard error == nil else {
//                    self.handleError(error)
//                    return
//                }
//                
//                // Most geocoding requests contain only one result.
//                if let firstPlacemark = placemarks?.first {
//                    self.mostRecentPlacemark = firstPlacemark
//                    self.currentCity = firstPlacemark.locality
//                }
//            }
//        }
    
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

