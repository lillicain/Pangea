//
//  PostViewModel.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import PhotosUI

@MainActor
class PostViewModel: ObservableObject {
    @Published var postImage: Image?
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task {
                await loadImage(fromItem: selectedImage)
            }
        }
    }
    
    var uiImage: UIImage?

    static let shared = PostViewModel()
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else {
            print("❌ No PhotosPickerItem found.")
            return
        }

        do {
            let data = try await item.loadTransferable(type: Data.self)
            print("📸 Image data loaded successfully: \(data!.count) bytes")

            if let uiImage = UIImage(data: data!) {
                self.uiImage = uiImage
                self.postImage = Image(uiImage: uiImage)
                print("✅ UIImage successfully created and assigned.")
            } else {
                print("❌ Failed to convert image data to UIImage.")
            }
        } catch {
            print("❌ Error loading image from picker item: \(error.localizedDescription)")
        }
    }
//    func loadImage(fromItem item: PhotosPickerItem?) async {
//        guard let item = item else { return }
//        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
//        guard let uiImage = UIImage(data: data) else { return }
//        self.uiImage = uiImage
//        self.postImage = Image(uiImage: uiImage)
//    }
    
    func uploadPost(description: String, location: String) async throws {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        guard let uiImage = uiImage else { return }
        let posts = Firestore.firestore().collection("posts").document()
//        guard let imageUrl = try await ImageManager.uploadImage(image: uiImage) else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ No user session.")
            return
        }
        guard let uiImage = uiImage else {
            print("❌ No image selected.")
            return
        }
        guard let imageUrl = try await ImageManager.uploadImage(image: uiImage) else { return }
        guard let coordinate = LocationManager().locationManager.location?.coordinate else {
            print("❌ No location available.")
            return
        }
//        guard let coordinate = LocationManager().locationManager.location?.coordinate else { return }
        
//        let post = Post(id: posts.documentID, userUid: uid, description: description, count: 0, imageUrl: imageUrl, timestamp: Timestamp(), location: location)
        
        let post = Post(id: posts.documentID, userUid: uid, description: description, count: 0, imageUrl: imageUrl, timestamp: Timestamp(), location: location, latitude: coordinate.latitude, longitude: coordinate.longitude)
                        
        guard let encodedPost = try? Firestore.Encoder().encode(post) else { return }
        try await posts.setData(encodedPost, merge: false)
    }
}
