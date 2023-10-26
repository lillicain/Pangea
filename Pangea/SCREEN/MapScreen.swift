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
