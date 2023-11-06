//
//  LocationInformationView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/31/23.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct LocationInformation: View {
    @Binding var selectedResult: MKMapItem?
    @Binding var showDetails: Bool
    @Binding var getDirections: Bool
    
    @Binding var lookAroundScene: MKLookAroundScene?
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
  
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(selectedResult?.placemark.name ?? "")
                        .font(FontOne.small)
                        .padding(.bottom, 2.5)
                        .padding(.trailing)
                    
                    Text(selectedResult?.placemark.title ?? "")
                        .lineLimit(2)
                        .padding(.trailing)
                }
                .padding(5)
                
                Spacer()
                
                Button {
                    dismiss()
                    showDetails.toggle()
                    selectedResult = nil
                    
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.gray, Color(.systemGray3))
                }
                .padding(5)
            }
            .padding(.horizontal)
            .padding(.top)
            
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 150)
                    .cornerRadius(25)
                    .padding()
                
            } else {
                LookAroundPreview(initialScene: lookAroundScene)
                    .frame(height: 150)
                    .cornerRadius(25)
                    .padding()
            }
            
            HStack(spacing: 25) {
                Button {
                    if let selectedResult {
                        selectedResult.openInMaps()
                    }
                } label: {
                    Text("Open Maps")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(authenticationViewModel.blue[0])
                        .cornerRadius(15)
                }
                
                Button {
                    getDirections = true
                    showDetails = false
                    
                } label: {
                    Text("Get Directions")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(authenticationViewModel.blue[0])
                        .cornerRadius(15)
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

extension LocationInformation {
    
    func fetchLookAroundPreview() {
        if let selectedResult {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: selectedResult)
                lookAroundScene = try? await request.scene
            }
        }
    }
}
