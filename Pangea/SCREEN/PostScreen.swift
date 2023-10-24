//
//  PostView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI
import PhotosUI
import AVKit

struct PostScreen: View {
    
    @StateObject var postViewModel = PostViewModel()
    
    @State var caption = ""
    @State var image: UIImage?
    @State var showCamera = false
    @State var showImagePicker = false
    
    var body: some View {
        ZStack {
            VStack {
                    if let image = postViewModel.postImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                            .clipped()
                    }
                
                TextField("Enter Text...", text: $caption)
                    .frame(width: UIScreen.main.bounds.width, height: 100)
                    .padding(.leading, 25)
                    .padding()
                  
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
                   
                    if image != nil {
                        Image(uiImage: image!)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: 350)
                    }
                
                Spacer()
             
            }
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
                    }
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

#Preview {
    PostScreen()
}
