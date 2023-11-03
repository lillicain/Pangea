//
//  MapInformation.swift
//  Pangea
//
//  Created by Lillian Cain on 11/1/23.
//

import SwiftUI
import MapKit

struct MapInformation: View {
    
    @Namespace var mapScope
    
    var body: some View {
        Map(scope: mapScope)
            .overlay(alignment: .bottomTrailing) {
                VStack {
                    MapUserLocationButton(scope: mapScope)
                    MapPitchToggle(scope: mapScope)
                    MapCompass(scope: mapScope)
                        .mapControlVisibility(.visible)
                }
                .padding(.trailing, 50)
                .buttonBorderShape(.circle)
            }
        .mapScope(mapScope)
    }
}

//struct Information: View {
//    @Binding var selectedResult: MKMapItem
//    @Binding var lookAroundScene: MKLookAroundScene?
//    
//    var body: some View {
//        LookAroundPreview(initialScene: lookAroundScene)
//            .overlay(alignment: .bottomTrailing) {
//                HStack {
//                    Text(selectedResult.name ?? selectedResult.description)
//                    
//                }
//            }
//            .onAppear {
//                fetchLookAroundPreview()
//            }
//            .onChange(of: selectedResult) { oldValue, newValue in
//                fetchLookAroundPreview()
//            }
//    }
//}
//
//extension Information {
//    
//    func fetchLookAroundPreview() {
//            lookAroundScene = nil
//            Task {
//                let request = MKLookAroundSceneRequest(mapItem: selectedResult)
//                lookAroundScene = try? await request.scene
//        }
//    }
//}
