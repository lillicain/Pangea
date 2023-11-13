//
//  SingleLocationPostView.swift
//  Pangea
//
//  Created by Lillian Cain on 11/13/23.
//

import SwiftUI
import MapKit

struct SingleLocationPostView: View {
    
    let post: Post
    
    @StateObject var sLPViewModel = SingleLocationPostViewModel()
    
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var results = [MKMapItem]()
    @State var visibleRegion: MKCoordinateRegion?
    @State var username = "User Test"
    
    var body: some View {
        VStack {
            mapView
        }
        .mapStyle(.standard(elevation: .realistic))
        .safeAreaPadding(.top, 25)
        .safeAreaPadding(.trailing, 5)
        .mapControls {
            MapInformation()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                MapItemView(cameraPosition: $cameraPosition, results: $results, visibleRegion: $visibleRegion, username: $username)
                    .padding(.leading, 315)
                    .padding(.bottom, 50)
            }
        }
        .frame(width: 375, height: 625)
        .cornerRadius(50)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 65, style: .circular)
//                .foregroundColor(authenticationViewModel.blue[0])
                .foregroundStyle(Color.blue) // Change later
                .frame(width: 405, height: 650)
        )
    }
}

extension SingleLocationPostView {
    var mapView: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()
            
            // Dont leave this here
//            Annotation("Home", coordinate: .homeLocation) {
//                homeAnnotation
//            }
            
            Annotation("Post", coordinate: CLLocationCoordinate2D(latitude: sLPViewModel.latLong.0, longitude: sLPViewModel.latLong.1)) {
                Circle()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(Color.green)
            }
//            sLPViewModel.getAnnotation(geoCoder: geoCoder, post: post)
            
        }
        .task {
            await sLPViewModel.foo(post: post)
        }
    }
    
    var homeAnnotation: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
            Circle()
                .frame(width: 45, height: 45)
//                .foregroundColor(authenticationViewModel.pink[0])
            Image(systemName: "house")
                .foregroundColor(.white)
        }
    }
}

//Annotation("Post", coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)) {
//    Circle()
//        .frame(width: 200)
//        .foregroundStyle(Color.green)
//}


