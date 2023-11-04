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
