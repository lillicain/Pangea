//
//  LocationView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/27/23.
//

import SwiftUI
import MapKit

struct LocationView: View {
    
    @State var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State var searchText = ""
    @State var results = [MKMapItem]()
    
    var body: some View {
        Map(position: $cameraPosition) {
        
        Marker("ME", coordinate: .userLocation)
        
        UserAnnotation()
        
            Annotation("MY ANNOTATION", coordinate:  .userLocation) {
                
                ZStack {
                    Circle()
                        .frame(width: 50)
                }
            }
            ForEach(results, id: \.self) { item in
                let placemark = item.placemark
                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
            }
            
        }
        .overlay {
            TextField("Search", text: $searchText)
        }
        .onSubmit(of: .text) {
            Task {
                await searchPlaces()
            }
        }
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
}
