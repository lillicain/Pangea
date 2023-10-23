//
//  MapView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI
import MapKit
import CoreLocationUI
import CoreLocation

struct MapView: View {
    @StateObject var locationManager = MapViewModel()
   
    var body: some View {
        HStack {
            if let place = locationManager.place {
                Text("\(place)")
                
            }
            
            LocationButton(.currentLocation) {
                locationManager.requestLocation()
            }
        }
    }
}

#Preview {
    MapView()
}

struct MapItemView: View {
    @Binding var position: MapCameraPosition
    @Binding var results: [MKMapItem]
    @Binding var visibleRegion: MKCoordinateRegion?
    @Binding var username: String
    
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
                position = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 37.0974, longitude: -113.5915), distance: 900, heading: 300, pitch: 63))
            } label: {
                Image(systemName: "rotate.3d")
            }
            
            LocationButton(.currentLocation) { }
                
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.borderedProminent)
    }
}

struct MapControlView: View {
    @Namespace var mapScope
    
    var body: some View {
        ZStack {
            MapUserLocationButton(scope: mapScope)
            MapPitchToggle(scope: mapScope)
            MapCompass(scope: mapScope)
                .mapControlVisibility(.visible)
        }
        .padding()
        .buttonBorderShape(.circle)
        .mapScope(mapScope)
    }
}

struct LocationInformationView: View {
    @Binding var selectedResult: MKMapItem?
    @Binding var isShowing: Bool
    @Binding var getDirections: Bool
    
    @State var lookAroundScene: MKLookAroundScene?
    
    func fetchLookAroundPreview() {
        if let selectedResult {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: selectedResult)
                lookAroundScene = try? await request.scene
            }
        }
    }
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(selectedResult?.placemark.name ?? "")
                
                    Text(selectedResult?.placemark.title ?? "")
                       
                }
                
                Spacer()
                
                Button {
                    isShowing.toggle()
                    selectedResult = nil
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.gray, Color(.systemGray5))
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding()
            } else {
                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
            }
            
            HStack(spacing: 25) {
                Button {
                    if let selectedResult {
                        selectedResult.openInMaps()
                    }
                } label: {
                    Text("Open Maps")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(.green)
                        .cornerRadius(10)
                }
                
                Button {
                    getDirections = true
                    isShowing = false
                    
                } label: {
                    Text("Get Directions")
                        .frame(width: 150, height: 50)
                        .cornerRadius(5)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: selectedResult) { oldValue, newValue in
            fetchLookAroundPreview()
        }
    }
}

