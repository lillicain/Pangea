//
//  ViewOne.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI

struct ViewOne: View {
    var body: some View {
        ZStack {
            
        }
    }
}

#Preview {
    ViewOne()
}

struct ProfileView: View {
    let user: User
    
    var body: some View {
        ScrollView {
            ProfileInformationView(user: user)
            PostItemView(user: user)
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    MapViewRepresentable(username: user.username)
                } label: {
                    Image(systemName: "mappin")
                }
            }
        }
    }
}

struct CurrentUserProfileView: View {
    let user: User
    
    var body: some View {
        ScrollView {
            ProfileInformationView(user: user)
            PostItemView(user: user)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    AuthenticationViewModel.shared.signOut()
                } label: {
                    Image(systemName: "house")
                }
            }
        }
    }
}

struct ProfileInformationView: View {
    @State var showEditProfile = false
    
    let user: User
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                ProfileImageManager(user: user, size: .large)
                    .padding(.top)
                
                Spacer()
                
                HStack(spacing: 5) {
//                    UserStatusView(value: 3, title: "Posts")
//                    UserStatusView(value: 3, title: "Friends")
                }
                .padding(5)
            }
            .padding(.horizontal)
            .padding(2.5)
            
            VStack(alignment: .leading, spacing: 5) {
                
                if let name = user.name {
                    Text(name)
                        .fontWeight(.bold)
                        .font(.footnote)
                }
                if let profileInformation = user.profileInformation {
                    Text(profileInformation)
                        .font(.footnote)
                }
                Text(user.username)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(2.5)
            
            Button {
                if user.isCurrentUser {
                    showEditProfile.toggle()
                }
                
            } label: {
                Text(user.isCurrentUser ? "Edit Profile" : "Add Friend")
                    .font(.subheadline)
                    .frame(width: 350, height: 35)
                    .background(user.isCurrentUser ? .white : Color(.systemGreen))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(user.isCurrentUser ? .gray : .clear))
            }
            Divider()
        }
        .fullScreenCover(isPresented: $showEditProfile) {
            EditUserView(user: user)
        }
    }
}

