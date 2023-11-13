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
    
    @Published var latLong: (Double, Double) = (0.0, 0.0)
    
    @MainActor
    func foo(post: Post) async {
//        print("Post Address:\(post.location)")
        let geoCoder = CLGeocoder()
        
        Task {
            do {
                let coordinate = try await LocationManager().getCoordinateAsync(geocoder: geoCoder, addressString: post.location)
                latLong = (coordinate.latitude, coordinate.longitude)
                print(" lat:\(latLong.0)")
                print(" long:\(latLong.1)")
            } catch {
                print("error with foo:\(error)")
            }
        }
    }
}
