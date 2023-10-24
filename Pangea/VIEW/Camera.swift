////
////  Camera.swift
////  Pangea
////
////  Created by Lillian Cain on 10/22/23.
////
//
//import SwiftUI
//import AVKit
//import PhotosUI
//
//struct Camera: View {
//    @Environment(\.dismiss) var dismiss
//    @State var image: UIImage?
//    @State var showCamera = false
//
//    var body: some View {
//        ZStack {
//            Button {
//                self.showCamera.toggle()
//
//            } label: {
//                Image(systemName: "camera")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 100, height: 100)
//            }
//            if image != nil {
//                Image(uiImage: image!)
//                    .resizable()
//                    .frame(width: 400, height: 500)
//            }
//        }
//        .fullScreenCover(isPresented: $showCamera, onDismiss: { self.showCamera = false }) {
//            CameraViewController(selectedImage: $image)
//                .edgesIgnoringSafeArea(.all)
//        }
//    }
//}
