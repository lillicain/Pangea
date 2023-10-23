//
//  MapManager.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    var username = ""
    
    func makeCoordinator() -> MapViewRepresentable.Coordinator {
        return MapViewRepresentable.Coordinator(parent1: self)
    }
    
    let map = MKMapView()
    let manager = CLLocationManager()
    
    func makeUIView(context: UIViewRepresentableContext<MapViewRepresentable>) -> MKMapView {
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
        map.showsUserLocation = true
        manager.requestWhenInUseAuthorization()
        return map
    }
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapViewRepresentable>) { }
    
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
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let uid = self.authenticationViewModel.userSession?.uid else { return }
            let last = locations.last
            Firestore.firestore().collection("locations").document("sharing").setData(["updates" : [uid : GeoPoint(latitude: (last?.coordinate.latitude)!, longitude: (last?.coordinate.longitude)!)]]) { (err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
            }
        }
    }
}

class Observer: ObservableObject{
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
