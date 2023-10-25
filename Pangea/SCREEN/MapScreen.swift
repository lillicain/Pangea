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
           ZStack(alignment: .bottom) {
//               Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
//                   .edgesIgnoringSafeArea(.all)
               MapViewRepresentable()
                   .ignoresSafeArea(.all)
               
               LocationButton {
                   locationManager.requestLocation()
               }
               .cornerRadius(20)
               .labelStyle(.titleAndIcon)
               .symbolVariant(.fill)
               .foregroundColor(Color.white)
           }
       }
   }

#Preview {
    MapScreen()
}
