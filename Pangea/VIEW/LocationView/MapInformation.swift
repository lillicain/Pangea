//
//  MapInformation.swift
//  Pangea
//
//  Created by Lillian Cain on 11/6/23.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MapInformation: View {
    
    @Namespace var mapScope
    
    var body: some View {
        Map(scope: mapScope)
            .overlay {
                VStack {
                    MapUserLocationButton(scope: mapScope)
                    MapPitchToggle(scope: mapScope)
                
                    MapCompass(scope: mapScope)
                        .mapControlVisibility(.visible)
                }
                .padding()
                .buttonBorderShape(.circle)
            }
            .mapScope(mapScope)
    }
}
