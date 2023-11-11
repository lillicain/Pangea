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
                
                LazyVStack(spacing: 75) {
                    ForEach(feedViewModel.posts.reversed()) { post in
                        FeedItemView(post: post)
                    }
                }
                
                .task {
                    locationManager.requestLocation()
                    
                    try? await feedViewModel.fetchPosts()
                    try? await postViewModel.uploadPost(description: description, location: location)
                }
                .padding(.top)
            }
            .sheet(isPresented: $newPost, content: {
                postView
                    .presentationDetents([.height(650)])
                    .presentationCornerRadius(50)
                    .toolbar(.hidden, for: .navigationBar)
            })
    
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
            .background(LinearGradient(colors: [.clear, .clear, .clear, authenticationViewModel.violet[0].opacity(0.15)], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all))
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
            .onAppear {
                showImagePicker.toggle()
            }
            .photosPicker(isPresented: $showImagePicker, selection: $postViewModel.selectedImage)
        }
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
            
            TextField("Enter Text...", text: $description)
                .modifier(OneViewModifier())
                .scrollDismissesKeyboard(.automatic)
            
            VStack {
                Button {
                    
                    Task {
                        do {
                            try await postViewModel.uploadPost(description: description, location: locationManager.currentLocation)
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
                        .modifier(PostViewModifier())
                }
            }
            .padding()
            
            Divider()
            
            VStack {
                Text(locationManager.currentLocation)
                    .font(FontOne.body)
                    .padding(.all, 25)
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
                            .font(FontEight.title)
                            .foregroundColor(authenticationViewModel.blue[0])
                            .offset(x: -2.5, y: 2.5)
                            .kerning(1.5)
                            .overlay {
                                Text("Hello, \(user)")
                                    .font(FontEight.title)
                                    .kerning(1.5)
                                    .foregroundColor(authenticationViewModel.green[0])
                                
                            }
                            .padding(.leading)
                            .padding(.all)
                            
                        
                        Spacer()
                    }
                }
                
                HStack {
                    Text("\(post.timestamp.dateValue())")
                        .font(FontFour.small)
                        .padding(.all)
                        .padding(.leading)
                        .foregroundColor(authenticationViewModel.blue[0])
                        .offset(x: -0.5, y: 0.5)
                        .background(
                            Text("\(post.timestamp.dateValue())")
                                .font(FontFour.small)
                                .padding(.all)
                                .padding(.leading)
                                .foregroundColor(.white)
                        )
                }
            }
        }
    }
}

