//
//  LocationUpdateManager.swift
//  Pangea
//
//  Created by Lillian Cain on 11/5/23.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseFirestore

class LocationUpdateManager: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var latitudine = 0.0
    var longitudine = 0.0
    var saveLatitudine = 0.0
    var saveLongitudine = 0.0
    var altitude = 0
    var meters: Double = 5000
    var previousLocation: CLLocation?
    
    var wholeLocation = [String : Any]()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitudine = location.coordinate.latitude
            longitudine = location.coordinate.longitude
//            let center = getCenterLocation(for: mapView)
            let geoCoder = CLGeocoder()
            altitude = Int(location.altitude)
            guard let previousLocation = self.previousLocation else { return }
            guard center.distance(from: previousLocation) > 100 else { return }
            self.previousLocation = center
            
            geoCoder.reverseGeocodeLocation(center) { [weak self]  (placemarks, error) in
                guard self != nil else {
                    return }
                if let _ = error {
                    print(error!)
                    return
                }
                guard let placemarks = placemarks?.first else {
                    return
                }
                let coordinates = placemarks.location
                self?.saveLatitudine = coordinates?.coordinate.latitude ?? 0.0
                self?.saveLongitudine = coordinates?.coordinate.longitude ?? 0.0
            print(location)
        }
    }
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        }
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longtitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longtitude)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
//            centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
//            previousLocation = getCenterLocation(for: mapView)
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation(){
        DispatchQueue.main.async { [self] in
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: meters, longitudinalMeters: meters)
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    
    func checkLocationServices() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.setupLocationManager()
                self.checkLocationAuthorization()
            }
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse:
            startTackingUserLocation()
            
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
            
        case .authorizedAlways:
            break
            
        default:
            break
        }
    }
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.tintColor = .red
        map.showsUserLocation = true
        map.isPitchEnabled = true
        map.isRotateEnabled = false
        map.isZoomEnabled = true
        map.isExclusiveTouch = true
        map.mapType = .standard
        map.delegate = self
        
        return map
    }()
    
    @objc func getUserLocation() {
        let coordinate = CLLocationCoordinate2D(latitude: latitudine, longitude: longitudine)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5 )
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func addAnnotation(latitude: Double, longitude: Double, title: String) {
        let coordinate = CLLocationCoordinate2D(latitude: latitudine, longitude: longitudine)
        let pin = MKPointAnnotation()
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5 )
        pin.coordinate = coordinate
        pin.title = "Places"
        mapView.delegate = self
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)

}
    
//    lazy var pinImage: UIImageView = {
//        let img = UIImageView()
//        img.translatesAutoresizingMaskIntoConstraints = false
//        img.image = UIImage(named: "pinImage")
//        img.contentMode = .scaleAspectFill
//        
//        
//        return img
//    }()
    
//    lazy var userLocationBtn: UIButton = {
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setImage(UIImage(named: "arrow"), for: .normal)
//        btn.layer.cornerRadius = 30
//        btn.imageView?.contentMode = .scaleAspectFill
//        
//        return btn
//    }()
//    
//    lazy var addPinBtn: UIButton = {
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setImage(UIImage(named: "addPin"), for: .normal)
//        btn.layer.cornerRadius = 15
//        btn.imageView?.contentMode = .scaleAspectFill
//        btn.addTarget(self, action: #selector(goToAddPin), for: .touchUpInside)
//        
//        return btn
//    }()
    
    let database = Firestore.firestore().collection("Locations")
    var dbLat = 0.0
    var dbLong = 0.0
    var userManager = UserManager.shared
    let postManager = PostManager.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServices()
        fetchAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAnnotations()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
//        initViews()
        checkLocationServices()
//        userLocationBtn.addTarget(self, action: #selector(getUserLocation), for: .touchUpInside)
        fetchAnnotations()
        
    }
}

      


extension LocationUpdateManager {
    
    func fetchAnnotations() {
        Firestore.firestore().collection("Locations").document("Locations").setData(["Location" : CLLocationCoordinate2D(latitude: dbLat, longitude: dbLong)])
//        database.observe(.value) { [self] snap in
   
        Firestore.firestore().collection("Locations").document("Location").addSnapshotListener { (snap, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            let updates = snap?.get("updates") as! [String : Any]
            self.dbLat = updates["latitude"] as! Double
            self.dbLong = updates["longtitude"] as! Double
        
            self.addAnnotation(latitude: self.dbLat, longitude: self.dbLong, title: "Post Locations")
            
//            self.data["data"] = updates
//            if snap.childrenCount != nil {
//                for i in 1...snap.childrenCount {
//                    database.child("\(i)").observe(.value) { [self] snap, key  in
//                        if let dictionary = snap.value as? [String: Any] {
                           
                    
            }
        }
    }
    
    
//    @objc func goToAddPin(){
//        let vc = AddPinVC()
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        vc.latForDB = saveLatitudine
//        vc.longForDB = saveLongitudine
//        present(vc, animated: true)
//    }
    
    


//extension LocationUpdateManager {
//    
//    
//    private func initViews(){
//        bgImage.isHidden = true
//        view.bringSubviewToFront(backBtn)
//        mapViewConst()
//        pinImageConst()
//        addPinBtnConst()
//        userLocbtnConst()
//    }
//    
//    
//    fileprivate func mapViewConst(){
//        view.addSubview(mapView)
//        view.sendSubviewToBack(mapView)
//        mapView.top(view.topAnchor)
//        mapView.bottom(view.bottomAnchor)
//        mapView.right(view.rightAnchor)
//        mapView.left(view.leftAnchor)
//    }
//    
//    
//    fileprivate func pinImageConst(){
//        mapView.addSubview(pinImage)
//        pinImage.centerY(mapView.centerYAnchor, -20)
//        pinImage.centerX(mapView.centerXAnchor)
//        pinImage.height(40)
//        pinImage.width(40)
//    }
//    
//    
//    fileprivate func userLocbtnConst(){
//        view.addSubview(userLocationBtn)
//        userLocationBtn.bottom(addPinBtn.topAnchor)
//        userLocationBtn.right(view.rightAnchor, -20)
//        userLocationBtn.height(60)
//        userLocationBtn.width(60)
//    }
//    
//    
//    fileprivate func addPinBtnConst(){
//        view.addSubview(addPinBtn)
//        addPinBtn.bottom(view.safeAreaLayoutGuide.bottomAnchor)
//        addPinBtn.right(view.rightAnchor, -10)
//        addPinBtn.height(90)
//        addPinBtn.width(110)
//    }
//    
//}



//extension LocationUpdateManager: MKMapViewDelegate {
//    
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let center = getCenterLocation(for: mapView)
//        let geoCoder = CLGeocoder()
//        latitudine = (locations.last?.coordinate.latitude)!
//        longitudine = (locations.last?.coordinate.longitude)!
//        guard let previousLocation = self.previousLocation else { return }
//        guard center.distance(from: previousLocation) > 100 else { return }
//        self.previousLocation = center
//        
//        geoCoder.reverseGeocodeLocation(center) { [weak self]  (placemarks, error) in
//            guard self != nil else {
//                return }
//            if let _ = error {
//                print(error!)
//                return
//            }
//            guard let placemarks = placemarks?.first else {
//                return
//            }
//            let coordinates = placemarks.location
//            self?.saveLatitudine = coordinates?.coordinate.latitude ?? 0.0
//            self?.saveLongitudine = coordinates?.coordinate.longitude ?? 0.0
//        }
//    }
//    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//    }
//}
////        if view.annotation != nil {
//////            let vc = locationManager
////            
////            let snapshot = try await postsCollection.getDocuments()
////            var posts = try snapshot.documents.compactMap({ try $0.data(as: Post.self) })
////        for index in wholeLocation {
////            let point = MKPointAnnotation()
////            point.coordinate = CLLocationCoordinate2D(latitude: index.value as! CLLocationDegrees, longitude: index.value as! CLLocationDegrees)
//            
////                database.child("\(i)").observe(.value) { [self] snap, key  in
////                    if let dictionary = snap.value as? [String: Any] {
////                        self.dbLat = dictionary["latitude"] as! Double
////                        self.dbLong = dictionary["longtitude"] as! Double
////                        
////                        if view.annotation?.coordinate.latitude == dbLat && view.annotation?.coordinate.longitude == dbLong {
//////                            uDManager.setIdForDB(count: i)
////                            print(uDManager.getIdForDB())
////                            vc.modalTransitionStyle = .crossDissolve
////                            vc.modalPresentationStyle = .fullScreen
////                            present(vc, animated: true)
//                        }
//                    }
//         
//
