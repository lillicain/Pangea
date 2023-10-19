//
//  LocationManager.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import Foundation
import UIKit
import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var place: String?
    
    let manager = CLLocationManager()
    
    
    override init() {
        super.init()
        manager.delegate = self
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lookUpCurrentLocation { placemark in
            self.place = placemark
        }
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
}


