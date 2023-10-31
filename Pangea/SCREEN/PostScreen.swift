//
//  PostView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI
import PhotosUI
import AVKit
import CoreLocationUI

struct PostScreen: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @StateObject var postViewModel = PostViewModel()
    @StateObject var locationManager = LocationManager()
    
    @State var caption = ""
    @State var image: UIImage?
    @State var showCamera = false
    @State var showImagePicker = false
    @State var date: Date?
    @State var currentLocation = ""
    @State var location: CLLocationCoordinate2D?
   
    
    var body: some View {
        ZStack {
            
            VStack {
                postInformation
                

            }
    
            .fullScreenCover(isPresented: $showCamera, onDismiss: { self.showCamera = false }) {
                CameraViewController(selectedImage: $image, date: $date, location: $location)
                    .ignoresSafeArea(.all)
            }
            
            .onAppear {
                showImagePicker.toggle()
            }
            .photosPicker(isPresented: $showImagePicker, selection: $postViewModel.selectedImage)
            
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        try await postViewModel.uploadPost(caption: caption)
                        postViewModel.uiImage = image
                        
                        if let postLocation = locationManager.placemark?.locality {
                            postViewModel.locationText = postLocation

                        }
                    }
                    currentLocation = ""
                    caption = ""
                    postViewModel.selectedImage = nil
                    postViewModel.postImage = nil
                    
                } label: {
                    Text("Post")
                }
            }
        }
    }
}

extension PostScreen {
    
    var postInformation: some View {
        VStack {
            if let image = postViewModel.postImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350, height: 350)
                    .clipped()
                    .padding()
            } else if image != nil {
                Image(uiImage: image!)
                    .scaledToFill()
                    .frame(width: 350, height: 350)
                    .clipped()
                    .padding()
            }
            
            TextField("Enter Text...", text: $caption)
                .frame(width: UIScreen.main.bounds.width, height: 100)
                .padding(.leading, 25)
                .padding()
            
            
            Divider()
            
            HStack {
                let currentLocation = locationManager.currentLocation
                
                Text(currentLocation ?? "")
                
                LocationButton(.currentLocation) {
                    locationManager.requestLocation()
                }
                .labelStyle(.titleAndIcon)
                .cornerRadius(7.5)
                .foregroundColor(.white)
                .padding()
            }
            
            Divider()
            
            if let date = date {
                Text("Created \(date)")
            }
            
            if let location = location {
                Text("Location: \(location.latitude), \(location.longitude)")
            }
            
            Text(locationManager.placemark?.locality ?? "")
            
            Text(locationManager.placemark?.name ?? "")
            
            Divider()
            
            Button {
                showCamera.toggle()
                image = postViewModel.uiImage
                location = postViewModel.locationForPost
                
            } label: {
                Text("Use Camera")
                    .fontWeight(.semibold)
                    .padding()
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding()
            }
            Spacer()
            
            
        }
    }
}
