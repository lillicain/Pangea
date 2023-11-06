////
////  LocationViewModel.swift
////  Pangea
////
////  Created by Lillian Cain on 11/3/23.
////
//
//import Foundation
//import SwiftUI
//import MapKit
//import CoreLocation
//im
//
//class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    let manager = CLLocationManager()
//    @Published var region: MKCoordinateRegion
//    @Published var location: CLLocationCoordinate2D?
//    @Published var name: String = ""
//
//    override init() {
//        let latitude = 0
//        let longitude = 0
//        self.region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude:
//                                                                        CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), span:
//                                            MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
//        super.init()
//        manager.delegate = self
//
//    }
//    func requestLocation() {
//        manager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //           location = locations.first?.coordinate
//        guard let location = locations.first else { return }
//        guard let uid = self.authenticationViewModel.userSession?.uid else { return }
//        let last = locations.last
//        Firestore.firestore().collection("locations").document("coordinates").setData(["updates" : [uid : GeoPoint(latitude: (last?.coordinate.latitude)!, longitude: (last?.coordinate.longitude)!)]], merge: true) { (err) in
//            if err != nil {
//                print((err?.localizedDescription)!)
//                return
//            }
//        }
//    }
//}
//update()
//}
//func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//    print("error:: \(error.localizedDescription)")
//}
//func update() {
//    let latitude = location?.latitude ?? 0
//    let longitude = location?.longitude ?? 0
//    self.region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude:
//                                                                    CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), span:
//                                        MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
//
//        guard let placemark = placemarks?.first else {
//            let errorString = error?.localizedDescription ?? "Unexpected Error"
//            print("Unable to reverse geocode the given location. Error: \(errorString)")
//            return
//        }
//
//        let reversedGeoLocation = GeoLocation(with: placemark)
//        self.name = reversedGeoLocation.name
//    }
//}
//func reverseUpdate() {
//    let geocoder = CLGeocoder()
//
//    geocoder.geocodeAddressString(name) { placemarks, error in
//
//        guard error == nil else {
//            print("*** Error in \(#function): \(error!.localizedDescription)")
//            return
//        }
//
//        guard let placemark = placemarks?[0] else {
//            print("*** Error in \(#function): placemark is nil")
//            return
//        }
//        let coord = placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude:
//                                                                                CLLocationDegrees(0), longitude: CLLocationDegrees(0))
//        self.region = MKCoordinateRegion(center: coord, span:
//                                            MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//        self.location = CLLocationCoordinate2D(latitude: placemark.location?.coordinate.latitude ?? 0, longitude: placemark.location?.coordinate.longitude ?? 0)
//
//    }
//
//}
//
//}
//
//struct GeoLocation {
//    let name: String
//    let streetName: String
//    let city: String
//    let state: String
//    let zipCode: String
//    let country: String
//    init(with placemark: CLPlacemark) {
//        self.name = placemark.name ?? ""
//        self.streetName = placemark.thoroughfare ?? ""
//        self.city = placemark.locality ?? ""
//        self.state = placemark.administrativeArea ?? ""
//        self.zipCode = placemark.postalCode ?? ""
//        self.country = placemark.country ?? ""
//    }
//
//}
////final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
////    var locationManager: CLLocationManager?
////
////    func checkIfLocationServicesIsEnabled() {
////        if CLLocationManager.locationServicesEnabled() {
////            locationManager = CLLocationManager()
////            checkLocationAuthorization()
////
////            locationManager = CLLocationManager()
////            locationManager!.delegate = self
////        } else {
////            print("Alert")
////        }
////    }
////
////   private func checkLocationAuthorization() {
////        guard let locationManager = locationManager else { return }
////
////        switch locationManager.authorizationStatus {
////
////        case .notDetermined: locationManager.requestAlwaysAuthorization()
////        case .restricted: print("Go to settings")
////        case .denied: print("Go to settings")
////        case .authorizedAlways, .authorizedWhenInUse: break
////
////        @unknown default:
////            break
////        }
////    }
////
////    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
////        checkLocationAuthorization()
////    }
////}
