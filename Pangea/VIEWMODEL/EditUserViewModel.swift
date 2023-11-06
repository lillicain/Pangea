//
//  EditUserViewModel.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import PhotosUI

@MainActor
class EditUserViewModel: ObservableObject {
    @Published var user: User
    @Published var name = ""
    @Published var profileInformation = ""
    @Published var profileImage: Image?
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task {
                await loadImage(fromItem: selectedImage)
            }
        }
    }
    
    private var uiImage: UIImage?
    
    init(user: User) {
        self.user = user
        if let name = user.name {
            self.name = name
        }
        if let profileInformation = user.profileInformation {
            self.profileInformation = profileInformation
        }
    }
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func updateUserData() async throws {
        var data = [String: Any]()
        if let uiImage = uiImage {
            let imageUrl = try? await ImageManager.uploadImage(image: uiImage)
            data["profileImage"] = imageUrl
        }
        if !name.isEmpty && user.name != name {
            data["name"] = name
        }
        if !profileInformation.isEmpty && user.profileInformation != profileInformation {
            data["profileInformation"] = profileInformation
        }
        if !data.isEmpty {
            try await Firestore.firestore().collection("users").document(user.id).updateData(data)
        }
    }
    
    func signOut() throws {
        AuthenticationViewModel.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationViewModel.shared.deleteAccount()
    }
}
