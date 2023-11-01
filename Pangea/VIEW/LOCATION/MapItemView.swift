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
    @Binding var cameraPosition: MapCameraPosition
    @Binding var results: [MKMapItem]
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var username: String
    
    @Namespace var mapScope
    
    var body: some View {
        ZStack {
        
            VStack(alignment: .trailing) {
                
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
                    cameraPosition = .automatic
                    
                } label: {
                    Image(systemName: "person.fill")
                }
                
                Button {
                    cameraPosition = .camera(MapCamera(centerCoordinate: .userLocation, distance: 750, heading: 150, pitch: 50))
                    
                } label: {
                    Image(systemName: "rotate.3d")
                }
            }
            .padding()
            .labelStyle(.iconOnly)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.circle)
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

