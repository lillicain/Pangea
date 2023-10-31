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
       @Binding var isShowing: Bool
       @Binding var getDirections: Bool
       
       @State var lookAroundScene: MKLookAroundScene?
       
       var body: some View {
           VStack {
               HStack {
                   VStack(alignment: .leading) {
                       Text(selectedResult?.placemark.name ?? "")
                       
                       Text(selectedResult?.placemark.title ?? "")
                           .lineLimit(2)
                           .padding(.trailing)
                   }
                   
                   Spacer()
                   
                   Button {
                       isShowing.toggle()
                       selectedResult = nil
                   } label: {
                       Image(systemName: "xmark")
                           .resizable()
                           .frame(width: 25, height: 25)
                           .foregroundStyle(.gray, Color(.systemGray5))
                   }
               }
               .padding(.horizontal)
               .padding(.top)
               
               if let scene = lookAroundScene {
                   LookAroundPreview(initialScene: scene)
                       .frame(height: 175)
                       .cornerRadius(15)
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
                           .background(Color(.systemGreen))
                           .cornerRadius(5)
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
