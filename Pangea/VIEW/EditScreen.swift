//
//  EditUserView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import SwiftUI
import PhotosUI

struct EditScreen: View {
    @AppStorage("appearance") var appearance: Bool = false
    @AppStorage("backgroundColors") var backgroundColors: String = ""
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @StateObject var editUserViewModel: EditUserViewModel
    
    init(user: User) {
        self._editUserViewModel = StateObject(wrappedValue: EditUserViewModel(user: user))
    }
    
    @State var size: CGFloat = 17.5
    @State var backgroundColor: Color = Color(.systemGray3)
    
    @State var backgroundColorSelected = ["ed4519", "8c00ff","ff0000","0000ff", "ff8300","ffff00", "2d00f7", "89fc00","f20089","ff006e", "a4f603", "C1FF00", "000000", "FFA617", "DD1F9F", "990DCE","243838", "B2FA63", "FF7833", "B2A1FF", "F3EDE1", "F85D32", "FC72AB", "D6D8F1", "19736B", "F4A44E", "455054", "308695", "D45769", "E69D45", "D4CFC9", "F2BB13", "442F73", "F2C2DC", "F26C1F", "FB2850", "FF006E", "80B918", "DDDF00", "F38375", "A5BE00", "1E96FC", "D264B6", "FF499E", "89FC00", "00E9D8", "F20089", "7014F2", "FF0000"]
    
    
    var body: some View {
        ZStack {
            VStack {
                PhotosPicker(selection: $editUserViewModel.selectedImage) {
                    VStack {
                        if let image = editUserViewModel.profileImage {
                            image
                                .resizable()
                                .background(Color(.systemGray))
                                .clipShape(Circle())
                                .padding()
                            
                        } else {
                            ProfileImageManager(user: editUserViewModel.user, size: .large)
                        }
                        Text("Edit Profile Picture")
                            .fontWeight(.semibold)
                        
                        Divider()
                    }
                    .padding(.vertical)
                }
                
                VStack(alignment: .leading, spacing: 7.5) {
                    Text(editUserViewModel.user.username)
                    Text(editUserViewModel.user.name ?? "")
                    Text(editUserViewModel.user.email)
                }
                .padding(.trailing, 175)
                
                
                Divider()
                Spacer()
                
                VStack {
                        Button {
                            AuthenticationViewModel.shared.signOut()
                            
                            Task {
                                authenticationViewModel.signOut()
                                authenticationViewModel.currentUser = nil
                            }
                        } label: {
                            Text("Sign Out")
                                .frame(width: 150, height: 50)
                                .background(Color(.systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 7.5))
                        }
                        .padding(.trailing, 175)
                        
                        Button(role: .destructive) {
                            Task {
                                try await authenticationViewModel.deleteAccount()
                            }
                        } label: {
                            Text("Delete Account")
                                .frame(width: 150, height: 50)
                                .background(Color(.systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 7.5))
                                
                        }
                        .padding(.trailing, 175)
                    }
                Divider()
        
                VStack {
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
                                .padding(.leading, 5)
                            }
                        }
                    }
                }
                
               Spacer()
                
               
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            try await editUserViewModel.updateUserData()
                        }
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}
