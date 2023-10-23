//
//  PostView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI
import CoreLocationUI

struct PostView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var postViewModel = PostViewModel()
//    @StateObject var mapViewModel = MapViewModel()

    @State var caption = ""
    @State var imagePickerPresented = false
    @State var image: UIImage?
    
    func clearData() {
        caption = ""
        postViewModel.selectedImage = nil
        postViewModel.postImage = nil
    }
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        clearData()
                    } label: {
                        Image(systemName: "clear")
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            try await postViewModel.uploadPost(caption: caption)
                            clearData()
                            
                            
                        }
                        
                        
                        
                    } label: {
                        Text("Post")
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                Divider()
                
                HStack {
                    if let image = postViewModel.postImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                    }
                    TextField("Enter...", text: $caption, axis: .vertical)
                }
                
                .padding()
                .padding(.top)
                
                Divider()
                    .padding(.top)
                
                VStack {
                    NavigationLink {
                        Camera()
                    } label: {
                        Text("Take A Photo...")
                    }
                }
                
                Spacer()
            }
            .onAppear {
                imagePickerPresented.toggle()
            }
            .photosPicker(isPresented: $imagePickerPresented, selection: $postViewModel.selectedImage)
            
        }
    }
}

#Preview {
    PostView()
}
