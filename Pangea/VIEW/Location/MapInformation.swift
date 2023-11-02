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
        ZStack {
            MapUserLocationButton(scope: mapScope)
            MapPitchToggle(scope: mapScope)
            MapCompass(scope: mapScope)
        }
        .padding()
        .mapScope(mapScope)
        .mapControlVisibility(.visible)
        .buttonBorderShape(.circle)
    }
}

#Preview {
    MapInformation()
}
