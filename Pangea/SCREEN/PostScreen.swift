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
    
    @StateObject var postViewModel = PostViewModel()
    
    @State var caption = ""
    @State var image: UIImage?
    @State var showCamera = false
    @State var showImagePicker = false
    @State var location = ""

    
    var body: some View {
        ZStack {
            
            AuthenticationViewModel().backgroundColor
                .ignoresSafeArea(.all)
            
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

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        try await postViewModel.uploadPost(caption: caption)
                        postViewModel.uiImage = image
//                        postViewModel.location = location
                    }
                    caption = ""
                    postViewModel.selectedImage = nil
                    postViewModel.postImage = nil
//                    location = ""
                    
                    
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
                TextField("Location", text: $location)
                    .padding(.leading, 50)
                
                CurrentLocationButton()
                    .padding(.trailing, 25)
                    .padding(.all)
               
                
            }
            
            Divider()
            
            
            Button {
                showCamera.toggle()
                image = postViewModel.uiImage
                
            } label: {
                Text("Use Camera")
                    .padding()
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding()
            }
       Spacer()
                
            
        }
    }
}
