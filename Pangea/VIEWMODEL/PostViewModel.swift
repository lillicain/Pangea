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
        guard let item = item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
    }
    
    func uploadPost(description: String, location: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let uiImage = uiImage else { return }
        let posts = Firestore.firestore().collection("posts").document()
        guard let imageUrl = try await ImageManager.uploadImage(image: uiImage) else { return }
        let post = Post(id: posts.documentID, userUid: uid, description: description, count: 0, imageUrl: imageUrl, timestamp: Timestamp(), location: location)
        guard let encodedPost = try? Firestore.Encoder().encode(post) else { return }
        try await posts.setData(encodedPost, merge: false)
    }
}
