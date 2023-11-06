////
////  MapScreen.swift
////  Pangea
////
////  Created by Lillian Cain on 10/25/23.
////
//
//import SwiftUI
//import CoreLocationUI
//import MapKit
//
//struct MapScreen: View {
//    @StateObject var locationManager = LocationManager()
//    
//    
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            MapViewRepresentable()
//                .edgesIgnoringSafeArea(.top)
//            
//            LocationButton {
//                locationManager.requestLocation()
//            }
//            .cornerRadius(15)
//            .labelStyle(.titleAndIcon)
//            .foregroundColor(.white)
//            .padding()
//            
//            
//        }
//    }
//}
//
//#Preview {
//    MapScreen()
//}
//
//struct MapInformation: View {
//    
//    @Namespace var mapScope
//    
//    var body: some View {
//        Map(scope: mapScope)
//            .overlay(alignment: .bottomTrailing) {
//                VStack {
//                    MapUserLocationButton(scope: mapScope)
//                    MapPitchToggle(scope: mapScope)
//                    
//                    MapCompass(scope: mapScope)
//                        .mapControlVisibility(.visible)
//                }
//                .padding(.trailing, 50)
//                .buttonBorderShape(.circle)
//            }
//            .mapScope(mapScope)
//    }
//}
////struct CurrentLocationButton : View {
////
////    @StateObject var locationManager = LocationManager()
////    let onClick: () -> Void
////
////    var body: some View {
////        HStack {
////            let currentLocation = locationManager.currentLocation
////
////            Text(currentLocation ?? "")
////
////
////            LocationButton(.currentLocation) {
////                locationManager.requestLocation()
////                onClick()
////            }
////
////            .labelStyle(.iconOnly)
////            .cornerRadius(7.5)
////            .foregroundColor(.white)
////        }
////    }
////}
