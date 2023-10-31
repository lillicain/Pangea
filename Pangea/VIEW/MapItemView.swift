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
        @Binding var position: MapCameraPosition
        @Binding var results: [MKMapItem]
        @Binding var visibleRegion: MKCoordinateRegion?
        @Binding var username: String
        
        var body: some View {
            HStack {
                Button {
                    searchPlaces(for: "Parks")
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                
                Button {
                    searchPlaces(for: "Places")
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                    
                }
                
                Button {
                    position = .userLocation(fallback: .automatic)
                } label: {
                    Image(systemName: "person.fill")
                }
                
                Button {
                    position = .camera(MapCamera(centerCoordinate: .userLocation, distance: 900, heading: 300, pitch: 63))
                } label: {
                    Image(systemName: "rotate.3d")
                }
                
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.borderedProminent)
        }
    }

extension MapItemView {
    func searchPlaces(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0975, longitude: -113.599), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            results = response?.mapItems ?? []
        }
    }
}


//struct MapControlView: View {
//    @Namespace var mapScope
//
//    var body: some View {
//        ZStack {
//            MapUserLocationButton(scope: mapScope)
//            MapPitchToggle(scope: mapScope)
//            MapCompass(scope: mapScope)
//                .mapControlVisibility(.visible)
//        }
//        .padding()
//        .buttonBorderShape(.circle)
//        .mapScope(mapScope)
//    }
//}
