//
//  EditUserView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import SwiftUI
import PhotosUI

struct EditUserView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var editUserViewModel: EditUserViewModel
    
    init(user: User) {
        self._editUserViewModel = StateObject(wrappedValue: EditUserViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    Text("Edit Your Profile")
                    
                    Spacer()
                    
                    Button {
                        Task {
                            try await editUserViewModel.updateUserData()
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
            }
            
            PhotosPicker(selection: $editUserViewModel.selectedImage) {
                VStack {
                    if let image = editUserViewModel.profileImage {
                        image
                            .resizable()
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                    } else {
                        ProfileImageManager(user: editUserViewModel.user, size: .medium)
                    }
                    Text("Edit Profile Picture")
                        .fontWeight(.semibold)
                    
                    Divider()
                }
            }
            .padding(.vertical, 10)
            
            VStack {
                EditProfile(text: $editUserViewModel.name, title: "Name", placeholder: "Enter Name")
                EditProfile(text: $editUserViewModel.profileInformation, title: "Information", placeholder: "Enter Information")
            }
            
            Spacer()
        }
    }
}

//#Preview {
//    EditUserView()
//}

struct EditProfile: View {
    @Binding var text: String
    
    let title: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 5)
                .frame(width: 100, alignment: .leading)
            VStack {
                TextField(placeholder, text: $text)
                
                Divider()
            }
        }
        .frame(height: 50)
    }
}


