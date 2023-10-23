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
                HStack {
                    Text(editUserViewModel.name)
                        .padding(.leading)
                        .frame(alignment: .leading)
                    
                    VStack {
                        TextField("\(editUserViewModel.name)", text: $editUserViewModel.name)
                    }
                }
            }
            Divider()
            
            Spacer()
        }
    }
}

