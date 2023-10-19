//
//  MapItemView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI
import MapKit

struct MapItemView: View {
    @Binding var position: MapCameraPosition?
    @Binding var result: [MKMapItem]
    @Binding var userRegion: MKCoordinateRegion?
    @Binding var username: String?
    
    var body: some View {
        HStack {
            Button {
              
            } label: {
                Text("Search")
            }
        }
    }
}

//#Preview {
//    MapItemView()
//}

