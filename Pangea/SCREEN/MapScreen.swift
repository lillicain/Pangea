//
//  MapScreen.swift
//  Pangea
//
//  Created by Lillian Cain on 10/25/23.
//

import SwiftUI
import CoreLocationUI
import MapKit

struct MapScreen: View {
    @StateObject var locationManager = LocationManager()
    
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            MapViewRepresentable()
                .edgesIgnoringSafeArea(.top)
            
            LocationButton {
                locationManager.requestLocation()
            }
            .cornerRadius(15)
            .labelStyle(.titleAndIcon)
            .foregroundColor(.white)
            .padding()
            
            
        }
    }
}

#Preview {
    MapScreen()
}

//struct CurrentLocationButton : View {
//
//    @StateObject var locationManager = LocationManager()
//    let onClick: () -> Void
//
//    var body: some View {
//        HStack {
//            let currentLocation = locationManager.currentLocation
//
//            Text(currentLocation ?? "")
//
//
//            LocationButton(.currentLocation) {
//                locationManager.requestLocation()
//                onClick()
//            }
//
//            .labelStyle(.iconOnly)
//            .cornerRadius(7.5)
//            .foregroundColor(.white)
//        }
//    }
//}
