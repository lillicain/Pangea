//
//  ViewOne.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

//import SwiftUI
//
//struct UserStatusView: View {
//    let value: Int
//    let title: String
//
//    var body: some View {
//        VStack {
//            Text("\(value)")
//            Text(title)
//        }
//        .frame(width: 75)
//    }
//}

//struct ViewOne: View {
//    var body: some View {
//        ZStack {
//
//        }
//    }
//}
//
//#Preview {
//    ViewOne()
//}
//
//struct ProfileView: View {
//    let user: User
//
//    var body: some View {
//        ScrollView {
//           Screen(user: user)
//            PostItemView(user: user)
//        }
//        .navigationTitle(user.username)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink {
//
//                } label: {
//                    Text("Nothing yet")
//                }
//            }
//        }
//    }
//}

//struct CurrentUserProfileView: View {
//    let user: User
//
//    var body: some View {
//        ScrollView {
//            ProfileInformationView(user: user)
//            PostItemView(user: user)
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    AuthenticationViewModel.shared.signOut()
//                } label: {
//                    Image(systemName: "house")
//                }
//            }
//        }
//    }
//}
//
//struct ProfileInformationView: View {
//    @State var showEditProfile = false
//
//    let user: User
//
//    var body: some View {
//        VStack {
//            HStack {
//                ProfileImageManager(user: user, size: .large)
//                    .padding(.top)
//
////                Spacer()
////
////                HStack(spacing: 5) {
//////                    UserStatusView(value: 3, title: "Posts")
//////                    UserStatusView(value: 3, title: "Friends")
////                }
////                .padding(5)
//            }
////            .padding(.horizontal)
////            .padding(2.5)
//
//            VStack {
//                Text(user.username)
//                    .fontWeight(.bold)
//
//                if let name = user.name {
//                    Text(name)
//                        .fontWeight(.bold)
//                        .font(.footnote)
//                }
//                if let profileInformation = user.profileInformation {
//                    Text(profileInformation)
//                        .font(.footnote)
//                }
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.horizontal)
//            .padding(2.5)
//
//            Button {
//                if user.isCurrentUser {
//                    showEditProfile.toggle()
//                }
//
//            } label: {
//                Text(user.isCurrentUser ? "Edit Profile" : "Add Friend")
//                    .frame(width: 100, height: 50)
//                    .background(user.isCurrentUser ? .white : Color(.systemGreen))
//                    .foregroundColor(.black)
//                    .fontWeight(.semibold)
//                    .cornerRadius(5)
//                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(user.isCurrentUser ? Color(.systemGray) : .clear))
//            }
//            .frame(alignment: .trailing)
//            Divider()
//        }
//        .fullScreenCover(isPresented: $showEditProfile) {
//            EditUserView(user: user)
//
//        }
//    }
//}

