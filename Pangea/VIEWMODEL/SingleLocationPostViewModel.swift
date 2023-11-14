//
//  SingleLocationPostViewModel.swift
//  Pangea
//
//  Created by Lillian Cain on 11/13/23.
//

import Foundation
import SwiftUI
import MapKit

class SingleLocationPostViewModel: ObservableObject {
    
    @Published var coordinates: (Double, Double) = (0.0, 0.0)
    
    func getCoordinates(post: Post) async {
        let geocoder = CLGeocoder()
        
        Task {
            do {
                let coordinate = try await LocationManager().getCoordinateAsync(geocoder: geocoder, addressString: post.location)
                coordinates = (coordinate.latitude, coordinate.longitude)
                print("Latitude: \(coordinates.0)")
                print("Longitude: \(coordinates.1)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
