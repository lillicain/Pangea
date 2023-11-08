//
//  MapItemView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/31/23.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MapItemView: View {

    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    @ObservedObject var locationManager = LocationManager()
    
    @Binding var cameraPosition: MapCameraPosition
    @Binding var results: [MKMapItem]
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var username: String
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                Button {
                    cameraPosition = .automatic
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                
                Button {
                    if let location = locationManager.location?.coordinate {
                        visibleRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.longitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0), span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
                    }
//                    searchPlaces(for: post?.location ?? "2674 S 3970th Cir W")
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                
                Button {
                    searchPlaces(for: "Parks")
                    cameraPosition = .automatic
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                
                Button {
                    searchPlaces(for: "Places")
                    cameraPosition = .automatic
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                    
                }
                
                Button {
                    cameraPosition = .userLocation(fallback: .automatic)
                    
                } label: {
                    Image(systemName: "person.fill")
                }
                
                Button {
                    cameraPosition = .camera(MapCamera(centerCoordinate: .schoolLocation, distance: 980, heading: 242, pitch: 60))
                    
                } label: {
                    Image(systemName: "rotate.3d")
                }
            }
            .padding()
            .buttonBorderShape(.circle)
            .buttonStyle(.borderedProminent)
            .accentColor(authenticationViewModel.violet[0])
        }
    }
}

extension MapItemView {
    func searchPlaces(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0974, longitude: -113.5915), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            results = response?.mapItems ?? []
        }
    }
}

