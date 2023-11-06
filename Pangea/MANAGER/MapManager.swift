//
//  MapManager.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MapViewRepresentable: UIViewRepresentable {
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    var geopoints = [String : Any]()
    
    var username = ""
    var results = [MKMapItem]()
    var searchText = ""
    var cameraPosition: MapCameraPosition = .region(.userRegion)
    var selectedResult: MKMapItem?
    var position: MapCameraPosition = .automatic
    var visibleRegion: MKCoordinateRegion?
    
    func makeCoordinator() -> MapViewRepresentable.Coordinator {
        return MapViewRepresentable.Coordinator(parent1: self)
    }
    
    let map = MKMapView()
    let manager = CLLocationManager()
    
    func makeUIView(context: UIViewRepresentableContext<MapViewRepresentable>) -> MKMapView {
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
        map.showsUserLocation = true
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.094, longitude: -113.5915), span: MKCoordinateSpan(latitudeDelta: 10000, longitudeDelta: 10000))
//        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.094, longitude: -113.5915), latitudinalMeters: 10000, longitudinalMeters: 10000)
        map.region = region
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapViewRepresentable>) {
        for index in geopoints {
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: (index.value as AnyObject).latitude, longitude: (index.value as AnyObject).longitude)
            point.title = index.key
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(point)
        }
    }
    
    class Coordinator: NSObject, CLLocationManagerDelegate {
        @ObservedObject var authenticationViewModel = AuthenticationViewModel()
        
        var parent: MapViewRepresentable
        
        init(parent1: MapViewRepresentable) {
            parent = parent1
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .denied {
                print(status)
            }
            if status == .authorizedWhenInUse {
                print(status)
            }
            if status == .authorizedAlways {
                print(status)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let uid = self.authenticationViewModel.userSession?.uid else { return }
            let last = locations.last
            Firestore.firestore().collection("locations").document("coordinates").setData(["updates" : [uid : GeoPoint(latitude: (last?.coordinate.latitude)!, longitude: (last?.coordinate.longitude)!)]], merge: true) { (err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
            }
        }
    }
}

class Observer: ObservableObject {
    @Published var data = [String : Any]()
    
    init() {
        let db = Firestore.firestore()
        db.collection("locations").document("coordinate").addSnapshotListener { (snap, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            let updates = snap?.get("updates") as! [String : GeoPoint]
            self.data["data"] = updates
        }
    }
}
