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
import MapKit

struct FeedView: View {
    
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    @ObservedObject var locationManager = LocationManager()
    
    @StateObject var postViewModel = PostViewModel()
    @StateObject var feedViewModel = FeedViewModel()
    
    @State var searchText = ""
    @State var newPost = false
    @State var description = ""
    @State var location = ""
    @State var image: UIImage?
    @State var showCamera = false
    @State var showImagePicker = false
    
    let post: Post
    
    var body: some View {
        NavigationStack {
            ScrollView {
                userInformation
            
                    .padding(.top)
                    .padding(.bottom, 250)
                
                LazyVStack(spacing: 125) {
                    ForEach(feedViewModel.posts) { post in
                        FeedItemView(post: post)
                    }
                }
                
                .task {
                    locationManager.requestLocation()
                
                    try? await postViewModel.uploadPost(description: description, location: location)
                    try? await feedViewModel.fetchPosts()
                }
                .padding(.top)
            }
            .sheet(isPresented: $newPost, content: {
                postView
                    .presentationDetents([.height(750)])
                    .presentationCornerRadius(50)
                    .toolbar(.hidden, for: .navigationBar)
            })
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        SearchScreen()
                    } label: {
                        Image(systemName: "magnifyingglass.circle")
                            .imageScale(.large)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        newPost.toggle()
                    } label: {
                        Text("Create Post")
                    }
                }
            }
            .background(LinearGradient(colors: [.clear, .clear, .clear, authenticationViewModel.violet[0].opacity(0.175)], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all))
        }
    }
}

extension FeedView {
    
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
            .task {
                showImagePicker.toggle()
            }
            .photosPicker(isPresented: $showImagePicker, selection: $postViewModel.selectedImage)
        }
    }
    
    var postInformation: some View {
        VStack {
            VStack {
                if let image = postViewModel.postImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 350)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding()
                } else if image != nil {
                    Image(uiImage: image!)
                        .scaledToFill()
                        .frame(width: 350, height: 350)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding()
                }
            }
            .padding(.top, 75)
            .padding(.vertical)
            
            VStack {
                TextField("Enter Text...", text: $description)
                    .colorMultiply(.black)
                    .modifier(OneViewModifier())
            }
                
            VStack {
                Button {
                    Task {
                        do {
                            try await postViewModel.uploadPost(description: description, location: locationManager.currentLocation)
                            try await feedViewModel.fetchPosts()
                            
                            postViewModel.uiImage = image
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                    description = ""
                    postViewModel.selectedImage = nil
                    postViewModel.postImage = nil
                    
                } label: {
                    Text("Post")
                        .padding(.leading, 35)
                        .padding(.trailing, 35)
                        .modifier(PostViewModifier())
                }
                .padding(.all)
                .padding(.vertical)
            }
            
            VStack {
                Text(locationManager.currentLocation)
                    .font(FontOne.body)
                    .padding(.bottom, 25)
                    .padding(.vertical)
            }
            
            
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
    
    var userInformation: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    if let user = authenticationViewModel.currentUser?.username {
                        
                        Text("Hello, \(user)")
                            .font(FontEight.large)
                            .foregroundColor(authenticationViewModel.blue[0])
                            .offset(x: -2.5, y: 2.5)
                            .kerning(1.5)
                            .overlay {
                                Text("Hello, \(user)")
                                    .font(FontEight.large)
                                    .kerning(1.5)
                                    .foregroundColor(authenticationViewModel.green[0])
                            }
                            .padding(.leading)
                            .padding(.all, 5)
                    }
                }
                
                HStack {
                    Text("\(post.timestamp.dateValue())")
                        .font(FontFour.extraSmall)
                        .padding(.leading)
                        .padding(.all, 5)
                        .foregroundColor(authenticationViewModel.blue[0])
                        .offset(x: -0.25, y: -0.25)
                        .background(
                            Text("\(post.timestamp.dateValue())")
                                .font(FontFour.extraSmall)
                                .padding(.leading)
                                .padding(.all, 5)
                                .foregroundColor(authenticationViewModel.blue[0])
                        )
                }
    
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 3.5)
                    .padding(.top, 15)
                    .padding(.vertical)
                    .foregroundColor(authenticationViewModel.blue[0])
            }
        }
    }
}

