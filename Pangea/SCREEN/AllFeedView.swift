//
//  AllFeedView.swift
//  Pangea
//
//  Created by Lillian Cain on 11/2/23.
//

import SwiftUI

import PhotosUI
import AVKit
import CoreLocationUI

struct AllFeedView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var postViewModel = PostViewModel()
    @StateObject var locationManager = LocationManager()
    
    @StateObject var feedViewModel = FeedViewModel()
    
    @State var searchText = ""
    @State var newPost = false
    @State var caption = ""
    @State var image: UIImage?
    @State var showCamera = false
    @State var showImagePicker = false
    @State var location = ""
    
//    let post: Post
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(feedViewModel.posts, id: \.self) { post in
                    FeedScreen(post: post)
//                    locationManager.currentLocation = post.location
                }
            }
            .padding(.top)
        }
        .sheet(isPresented: $newPost, content: {
            postView
                .presentationDetents([.height(650)])
                .presentationCornerRadius(50)
        })
        .background(LinearGradient(colors: [.clear, .clear, .clear, authenticationViewModel.violet[0].opacity(0.15)], startPoint: .top, endPoint: .bottom))
        
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial.opacity(0.5), for: .tabBar)
    
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink {
                    SearchScreen()
                } label: {
                    Text("Search")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
               Button {
                   newPost.toggle()
                   
                } label: {
                    Text("Post")
                }
            }
        }
    }
}
   
//                Button {
//                    Task {
//                        do {
//                            try await postViewModel.uploadPost(caption: caption)
//                            postViewModel.uiImage = image
//                            locationManager.currentLocation = post.location
//                        } catch {
//
//                        }
//                        caption = ""
//                        postViewModel.selectedImage = nil
//                        postViewModel.postImage = nil
//                        postViewModel.location = ""
//                        locationManager.currentLocation = ""
//
//                    }
//                } label: {
//                    Text("Post")
//                }
      

extension AllFeedView {
    
    var postView: some View {
        ZStack {
            VStack {
                postInformation
            }
            
            .padding(.all)
            
            
            .fullScreenCover(isPresented: $showCamera, onDismiss: { self.showCamera = false }) {
                CameraViewController(selectedImage: $image)
                    .ignoresSafeArea(.all)
            }
            
            .onAppear {
                showImagePicker.toggle()
            }
            .photosPicker(isPresented: $showImagePicker, selection: $postViewModel.selectedImage)
            
        }
        
//        .background(LinearGradient(colors: [.clear, .clear, .clear, .clear, authenticationViewModel.violet[0].opacity(0.15)], startPoint: .top, endPoint: .bottom))
    }
    
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
                .modifier(OneViewModifier())
            
               
            VStack {
                Button {
                    Task {
                        
                        try await postViewModel.uploadPost(caption: caption)
                        postViewModel.uiImage = image
//                        locationManager.currentLocation// = post.location
                    }
                    caption = ""
                    postViewModel.selectedImage = nil
                    postViewModel.postImage = nil
                    postViewModel.location = ""
                    locationManager.currentLocation = ""
                    
                    
                } label: {
                    Text("Post")
                        .modifier(PostViewModifier())
                }
            }
            .padding()
            
            Divider()
            
            HStack {
                
//                Text(location)
                
                Text(locationManager.currentLocation ?? "")
                
                LocationButton(.currentLocation) {
                    locationManager.requestLocation()
                    
                }
                .labelStyle(.titleAndIcon)
                .cornerRadius(15)
                .foregroundColor(.white)
            
            }
            
            .padding()
            
            HStack(spacing: 25) {
                Button {
                    showCamera.toggle()
                    image = postViewModel.uiImage
                    
                } label: {
                    Text("Use Camera")
                        .modifier(PostViewModifier())
                }
                
                Button {
                    showImagePicker.toggle()
                } label: {
                    Text("Select Photo")
                        .modifier(PostViewModifier())
                }
            }

            
        }
    }
}
