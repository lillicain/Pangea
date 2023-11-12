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
            VStack {
                Button {
                    cameraPosition = .automatic
                } label: {
                    Image(systemName: "network")
                }
                
                Button {
                    cameraPosition = .userLocation(fallback: .automatic)
                    searchPlaces(for: "Park")

                } label: {
                    Image(systemName: "binoculars")
                }
                
                Button {
                    cameraPosition = .camera(MapCamera(centerCoordinate: .schoolLocation, distance: 980, heading: 242, pitch: 60))
                    
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                }
            }
            .controlSize(.regular)
            .buttonBorderShape(.circle)
            .buttonStyle(.borderedProminent)
            .accentColor(authenticationViewModel.pink[0])
        }
    }
}

extension MapItemView {
    func searchPlaces(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion()
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            results = response?.mapItems ?? []
        }
    }
}

