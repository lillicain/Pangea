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
import FirebaseFirestore
import FirebaseFirestoreSwift

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var place: String?
    @Published var region = MKCoordinateRegion()
    var post = [Post]()
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    let manager = CLLocationManager()
    let myPosition = CLLocationCoordinate2D()
    let mapView = MKMapView()
   
    override init() {
        super.init()
        manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.userTrackingMode = MKUserTrackingMode.follow
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        locations.last.map {
//            region = MKCoordinateRegion(center: $0.coordinate, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
//        }
//        
//        lookUpCurrentLocation { placemark in
//            self.place = placemark
//        }
//    }
    
    
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let uid = self.authenticationViewModel.userSession?.uid else { return }
        let last = locations.last
        locations.last.map {
            region = MKCoordinateRegion(center: $0.coordinate, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
        
        lookUpCurrentLocation { placemark in
            self.place = placemark
        }
        

        Firestore.firestore().collection("locations").document("sharing").setData(["updates" : [uid : GeoPoint(latitude: (last?.coordinate.latitude)!, longitude: (last?.coordinate.longitude)!)]]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
           
                
        }
    }
    
}
