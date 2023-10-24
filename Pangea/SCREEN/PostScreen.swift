////
////  PostScreen.swift
////  Pangea
////
////  Created by Lillian Cain on 10/24/23.
////
//
//import SwiftUI
//import PhotosUI
//import AVKit
//
//struct PostScreen: View {
//    
//    @StateObject var postViewModel = PostViewModel()
//    
//    @State var image: UIImage?
//    @State var showCamera = false
//    @State var showImagePicker = false
//    @State var caption = ""
//    
//    
//    var body: some View {
//        ZStack {
//            VStack {
//                if let image = postViewModel.postImage {
//                    image
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 300, height: 300)
//                        .clipped()
//                }
//                TextField("Enter...", text: $caption, axis: .vertical)
//                    .padding(.leading, 5)
//                //                Button {
//                //                    caption = ""
//                //                    postViewModel.selectedImage = nil
//                //                    postViewModel.postImage = nil
//                //                } label: {
//                //                    Text("Clear")
//                //                }
//                
//                
//                Button {
//                    showCamera.toggle()
//                } label: {
//                    Text("Camera")
//                }
//                if image != nil {
//                    Image(uiImage: image!)
//                        .resizable()
//                        .frame(width: UIScreen.main.bounds.width, height: 350)
//                }
//            }
//            .fullScreenCover(isPresented: $showCamera, onDismiss: { self.showCamera = false }) {
//                CameraViewController(selectedImage: $image)
//                    .ignoresSafeArea(.all)
//            }
//            .onAppear {
//                showImagePicker.toggle()
//            }
//            .photosPicker(isPresented: $showImagePicker, selection: $postViewModel.selectedImage)
//        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    Task {
//                        try await postViewModel.uploadPost(caption: caption)
//                        
//                        caption = ""
//                        postViewModel.selectedImage = nil
//                        postViewModel.postImage = nil
//                    }
//                } label: {
//                    Text("Post")
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    PostScreen()
//}
