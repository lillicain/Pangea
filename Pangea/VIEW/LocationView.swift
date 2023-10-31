//
//  LocationView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/31/23.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @State var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State var searchText = ""
    @State var results = [MKMapItem]()
    @State var selectedResult: MKMapItem?
    @State var showDetails = false
    @State var getDirections = false
    @State var routeDisplaying = false
    @State var route: MKRoute?
    @State var routeDestination: MKMapItem?
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectedResult) {
        
//        Marker("ME", coordinate: .userLocation)
        
//        UserAnnotation()
        
            Annotation("Me!", coordinate: .userLocation) {
                ZStack {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color(.systemBlue).opacity(0.25))
                    
                    Circle()
                        .frame(width: 22.5, height: 22.5)
                        .foregroundColor(.white)
                    
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundColor(Color(.systemBlue))
                }
            }
            ForEach(results, id: \.self) { item in
                if routeDisplaying {
                    if item == routeDestination {
                        let placemark = item.placemark
                        Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                    }
                } else {
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                }
            }
            if let route {
                MapPolyline(route.polyline)
                    .stroke(Color(.systemBlue), lineWidth: 5)
                
            }
        }
//        .overlay(alignment: .top) {
//            TextField("Search", text: $searchText)
//                .padding()
//                .background(.white)
//                .padding()
//        }
//        .onSubmit(of: .text) {
//            Task {
//                await searchPlaces()
//            }
//        }
        .onChange(of: getDirections, { oldValue, newValue in
            if newValue {
                fetchRoute()
            }
        })
        
        .onChange(of: selectedResult, { oldValue, newValue in
        showDetails = newValue != nil
            
        })
        .sheet(isPresented: $showDetails, content: {
            LocationInformation(selectedResult: $selectedResult, isShowing: $showDetails, getDirections: $getDirections)
                .presentationDetents([.height(250)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(250)))
                .presentationCornerRadius(25)
        })
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
    }
}

#Preview {
    LocationView()
}

extension LocationView {
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
    
    func fetchRoute() {
        if let selectedResult {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
            request.destination = selectedResult
            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                routeDestination = selectedResult
                withAnimation(.snappy) {
                    routeDisplaying = true
                    showDetails = false
                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
    }
}
