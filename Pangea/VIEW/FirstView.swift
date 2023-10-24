////
////  FirstView.swift
////  Pangea
////
////  Created by Lillian Cain on 10/23/23.
////
//
//import SwiftUI
//import MapKit
//
//struct FirstView: View {
//    @State var settings = false
//
//    let user: User
//
//    var body: some View {
//
//        ScrollView {
//
//            ZStack {
//
//                VStack {
//                    Map {
//
//                    }
//                    .frame(width: UIScreen.main.bounds.width, height: 250)
//                    .cornerRadius(50)
//                    .padding(.bottom, 50)
//                }
//                .tabItem { Image(systemName: "person.fill") }
//                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
//                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
//
//                ZStack {
//                    Circle()
//                        .frame(width: 152.5, height: 152.5)
//                        .foregroundColor(.white)
//
//                    ZStack {
//                        ProfileImageManager(user: user, size: .extraLarge)
//
//                    }
//                }
//                .background(.white)
//                .clipShape(.circle)
//                .padding(.top, 75)
//
//
//                //                    FeedView()
//                //                        .tabItem { Image(systemName: "globe")}
//            }
//            VStack(spacing: 7.5) {
//                Text(user.username)
//                    .fontWeight(.bold)
//
//                if let name = user.name {
//                    Text(name)
//                }
//                if let profileInformation = user.profileInformation {
//                    Text(profileInformation)
//                }
//                HStack {
//                    Spacer()
//                    Button {
//                        if user.isCurrentUser {
//                            settings.toggle()
//                        }
//                    } label: {
//                        Text(user.isCurrentUser ? "Edit Profile" : "Add Friend")
//                            .padding(7.5)
//                            .background(user.isCurrentUser ? Color(.systemGray3) : Color(.systemGreen))
//                            .foregroundStyle(.ultraThickMaterial).fontWeight(.bold)
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                            .padding(.bottom, 250)
//                    }
//                    .padding(.bottom, 25)
//                    .padding(.trailing)
//                }
//
//
//
//
//                .sheet(isPresented: $settings) {
//                    EditUserView(user: user)
//                }
//                .frame(height: 50)
//                
//                
//            }
//            
//            
//            
//            VStack {
//                PostItemView(user: user)
//            }
//            
//        }
//        .navigationTitle(user.username)
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                
//
//            }
//        }
//    }
//}
//
//#Preview {
//    FirstView(user: User.MOCK_USER)
//}
