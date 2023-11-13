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

struct MapManager: UIViewRepresentable {
    
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    @ObservedObject var locationManager = LocationManager()
    
    let map = MKMapView()
    let manager = CLLocationManager()
    
    var geocoder = CLGeocoder()
    var geopoint = [String : Any]()
    var post: Post?

    var results = [MKMapItem]()
    var cameraPosition: MapCameraPosition = .region(.userRegion)
    var selectedResult: MKMapItem?

    var region = MKCoordinateRegion()
    
    func makeCoordinator() -> MapManager.Coordinator {
        return MapManager.Coordinator(parents: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapManager>) -> MKMapView {
        manager.delegate = context.coordinator
        manager.startUpdatingLocation()
//        map.showsUserLocation = true
        map.region = region
        
        return map
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapManager>) {
        
        for index in geopoint {
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: (index.value as AnyObject).latitude, longitude: (index.value as AnyObject).longitude)
            point.title = index.key
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(point)
        }
        
        if let posts = post?.location {
            geocoder.geocodeAddressString(posts) { (placemark, error) in
                let item = placemark?.first?.location?.coordinate
                let point = MKPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: item?.latitude ?? 0.0, longitude: item?.longitude ?? 0.0)
                uiView.addAnnotation(point)
            }
        }
        
        func getCoordinate( addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
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
    
    
   class Coordinator: NSObject, CLLocationManagerDelegate {
        
        @ObservedObject var authenticationViewModel = AuthenticationViewModel()
        
        var parent: MapManager
        
        init(parents: MapManager) {
            parent = parents
        }
        
        
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            guard let uid = self.authenticationViewModel.userSession?.uid else { return }
//            let last = locations.last
//            Firestore.firestore().collection("locations").document("coordinates").setData(["updates" : [uid : GeoPoint(latitude: (last?.coordinate.latitude)!, longitude: (last?.coordinate.longitude)!)]], merge: true) { (err) in
//                if err != nil {
//                    print((err?.localizedDescription)!)
//                    return
//                }
//            }
//        }
    }
}

//class Observer: ObservableObject {
//    @Published var data = [String : Any]()
//    
//    init() {
//        let db = Firestore.firestore()
//        db.collection("locations").document("coordinate").addSnapshotListener { (snap, err) in
//            if err != nil{
//                print((err?.localizedDescription)!)
//                return
//            }
//            let updates = snap?.get("updates") as! [String : GeoPoint]
//            self.data["data"] = updates
//        }
//    }
//}
