//
//  MapView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MapView: View {
    @State var position: MapCameraPosition?
    @State var result = [MKMapItem]()
    @State var userRegion: MKCoordinateRegion?
    @State var username: String?
    @State var searchText = ""
    
    var body: some View {
        ScrollView {
            
            VStack {
                Map {
                    
                }
                .mapStyle(.standard(elevation: .realistic))
                .safeAreaInset(edge: .bottom) {
                    VStack {
                
                        
                        MapItemView(position: $position, result: $result, userRegion: $userRegion, username: $username)
                    }
                    
                }
            }
            .frame(width: 375, height: 575)
            .cornerRadius(25)
            
            VStack {
                TextField("Search...", text: $searchText)
                    .modifier(MaterialViewModifier())
                    .onSubmit(of: .text) {
                        Task {
                            searchPlaces
                        }
                    }
            }
            
            VStack {
                CurrentLocationButton()
            }
            
        }
    }
}

#Preview {
    MapView()
}

extension MapView {
    
    func searchPlaces(for query: String?) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = userRegion ?? MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0975, longitude: -113.599), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            result = response?.mapItems ?? []
        }
    }
}

