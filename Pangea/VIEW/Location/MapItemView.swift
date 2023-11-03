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
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @Binding var cameraPosition: MapCameraPosition
    @Binding var results: [MKMapItem]
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var username: String
    
    @Namespace var mapScope
    
    var body: some View {
        ZStack {
            VStack {
                
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
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.circle)
            .accentColor(authenticationViewModel.blue[0])
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

