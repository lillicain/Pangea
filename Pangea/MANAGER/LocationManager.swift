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
    
    private static let locationDistance: CLLocationDistance = 10000
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.094, longitude: -113.5915), latitudinalMeters: LocationManager.locationDistance, longitudinalMeters: LocationManager.locationDistance)

    @Published var authorizationState: CLAuthorizationStatus?
      @Published var placemark: CLPlacemark?
      @Published var heading: CLHeading?
      @Published var location: CLLocation?
      @Published var currentLocation: String?
      @Published var userLocation: CLLocation?
      
      @ObservedObject var authenticationViewModel = AuthenticationViewModel.shared
      
    
//    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    override init() {
        super.init()
        manager.activityType = .automotiveNavigation
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            self.location = location
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { placemarks, error in
              self.placemark = placemarks?.last
            }
          
        
            lookUpCurrentLocation { placemark in
                self.currentLocation = placemark
            }
            
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: Self.locationDistance, longitudinalMeters: Self.locationDistance)
                
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
        func getCoordinate(addressString : String,
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
    }

    //extension LocationManager {
    //  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    //    self.authorizationState = manager.authorizationStatus
    //
    //    if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
    //      manager.startUpdatingLocation()
    //
    //    } else if manager.authorizationStatus == .denied {
    //
    //    }
    //  }
    //}




//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        
//        lookUpCurrentLocation { placemark in
//            self.currentLocation = placemark
//        }
//        
//        DispatchQueue.main.async {
//            self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: Self.locationDistance, longitudinalMeters: Self.locationDistance)
//            
//        }
//        print(location.description)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
//    
//    func lookUpCurrentLocation(completionHandler: @escaping (String?) -> Void) {
//        if let lastLocation = manager.location {
//            let geocoder = CLGeocoder()
//            
//            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
//                
//                if error == nil {
//                    
//                    let firstLocation = placemarks?[0].name
//                    completionHandler(firstLocation)
//                    
//                } else {
//                    completionHandler(nil)
//                }
//            })
//        } else {
//            completionHandler(nil)
//        }
//    }
//}
