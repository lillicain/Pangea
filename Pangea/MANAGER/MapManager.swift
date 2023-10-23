//
//  MapManager.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import MapKit
import CoreLocation
import CoreLocationUI

struct MapViewRepresentable: UIViewRepresentable {
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
//    @Binding var posts: [Post]
    
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
//        func updateUserLocation() {
//            let db = Firestore.firestore()
//            let locman = CLLocationManager()
//            locman.requestWhenInUseAuthorization()
//            var loc:CLLocation!
//            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways{
//                loc = locman.location
//            }
//            let lat:Double = loc.coordinate.latitude
//            let long:Double = loc.coordinate.longitude
//            let geo = GeoPoint.init(latitude: lat, longitude: long)
//
//            let currentUID = authenticationViewModel.currentUser
////            let val = db.collection("users").whereField("uid", isEqualTo: currentUserUID)
//            db.collection("users").whereField("uid", isEqualTo: currentUID).updateData(["currentUserLocation" : geo])
////            db.collection("users").document(val).updateData(["currentUserLocation" : geo])
//
//        }
        
//        func lookUpCurrentLocation(completionHandler: @escaping (String?) -> Void) {
//            if let lastLocation = manager.location {
//                let geocoder = CLGeocoder()
//                
//                geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
//                    
//                    if error == nil {
//                        let firstLocation = placemarks?[0].name
//                        completionHandler(firstLocation)
//                    } else {
//                        completionHandler(nil)
//                    }
//                })
//            } else {
//                completionHandler(nil)
//            }
//        }
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




struct CustomPhotoPickerView: UIViewControllerRepresentable {
        
    @Binding var selectedImage: UIImage?
    @Binding var date: Date?
    @Binding var location: CLLocationCoordinate2D
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 1
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> CustomPhotoPickerView.Coordinator {
        return Coordinator(self)
    }
    
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }
            
            let imageResult = results[0]
            
            if let assetId = imageResult.assetIdentifier {
                let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                DispatchQueue.main.async {
                    self.parent.date = assetResults.firstObject?.creationDate
                    if let coordinate  = assetResults.firstObject?.location?.coordinate {
                        self.parent.location = coordinate
                    }
                }
            }
            if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        DispatchQueue.main.async {
                            self.parent.selectedImage = selectedImage as? UIImage
                        }
                    }
                }
            }
        }
        
        private let parent: CustomPhotoPickerView
        init(_ parent: CustomPhotoPickerView) {
            self.parent = parent
        }
    }
}
