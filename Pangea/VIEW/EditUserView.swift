//
//  EditUserView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import SwiftUI
import PhotosUI

struct EditUserView: View {
    @AppStorage("appearance") var appearance: Bool = false
    @AppStorage("backgroundColors") var backgroundColors: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @StateObject var editUserViewModel: EditUserViewModel
    
    @State var size: CGFloat = 17.5
    @State var backgroundColor: Color = Color(.systemGray3)
    
    @State var backgroundColorSelected = ["ed4519", "8c00ff","ff0000","0000ff", "ff8300","ffff00", "2d00f7", "89fc00","f20089","ff006e", "a4f603", "C1FF00", "000000", "FFA617", "DD1F9F", "990DCE","243838", "B2FA63", "FF7833", "B2A1FF", "F3EDE1", "F85D32", "FC72AB", "D6D8F1", "19736B", "F4A44E", "455054", "308695", "D45769", "E69D45", "D4CFC9", "F2BB13", "442F73", "F2C2DC", "F26C1F", "FB2850", "FF006E", "80B918", "DDDF00", "F38375", "A5BE00", "1E96FC", "D264B6", "FF499E", "89FC00", "00E9D8", "F20089", "7014F2", "FF0000"]
    
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
                .padding()
                .navigationBarTitleDisplayMode(.inline)
            }
            
            PhotosPicker(selection: $editUserViewModel.selectedImage) {
                VStack {
                    if let image = editUserViewModel.profileImage {
                        image
                            .resizable()
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                            .padding()
                    } else {
                        ProfileImageManager(user: editUserViewModel.user, size: .medium)
                    }
                    Text("Edit Profile Picture")
                        .fontWeight(.semibold)
                    
                    Divider()
                }
            
            .padding(.vertical)
        }
           
            Spacer()
            VStack {
                Text(editUserViewModel.user.username)
                Text(editUserViewModel.user.name ?? "")
                Text(editUserViewModel.user.email)
               
            }
    
              
              userInformation2
            userOptions
               
                userSettings
            
            
        }
    }
}

extension EditUserView {
    var userInformation: some View {
        VStack {
            Text(editUserViewModel.user.username)
            Text(editUserViewModel.user.name ?? "")
            Text(editUserViewModel.user.email)
           
        }
    }
    
    var userOptions: some View {
        VStack {
            Button {
                AuthenticationViewModel.shared.signOut()
                
                Task {
                    authenticationViewModel.signOut()
                    authenticationViewModel.currentUser = nil
                }
            } label: {
                Text("Sign Out")
                    .frame(height: 30)
            }
            
            Button(role: .destructive) {
                Task {
                    try await authenticationViewModel.deleteAccount()
                }
            } label: {
                Text("Delete Account")
                    .frame(height: 30)
            }
        }
    }
    
    var userSettings: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                
                ForEach(backgroundColorSelected.hexToColorArray(), id: \.self) { color in
                    Button(action: {
                        backgroundColor = color
                        authenticationViewModel.backgroundColor = color
                        backgroundColors = color.hexString ?? color.ColorToString()
                       
                    }, label: {
                        ZStack {
                            withAnimation(.spring()) {
                                Circle()
                                    .fill(color)
                                    .frame(width: 50, height: 50)
                                    .padding(3.5)
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    var userInformation2: some View {
        VStack {
            Toggle(appearance ? "Dark Mode" : "Light Mode", isOn: $appearance)
                .padding(3.5)
                .font(.system(size: size))
                .modifier(DarkModeViewModifier())
                .onTapGesture {
                    appearance.toggle()
                }
            
            Slider(value: $size, in: 15...45)
                .padding(5)
        }
    }
}

