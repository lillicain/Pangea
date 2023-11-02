//
//  Screen.swift
//  Pangea
//
//  Created by Lillian Cain on 10/24/23.
//

import SwiftUI
import MapKit

struct Screen: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var editUserViewModel: EditUserViewModel
    
    @State var showScreen = false
    
    let user: User
    
    var body: some View {
        TabView {
            ScrollView {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50, style: .circular)
                            .foregroundColor(authenticationViewModel.blue[0])
                            .frame(width: UIScreen.main.bounds.width, height: 250)
                            .padding(.bottom, 57.5)
                        
                        ZStack {
                            LocationView()
                                .frame(width: 375, height: 250)
                                .cornerRadius(50)
                                .padding(.bottom, 75)
                                .clipShape(RoundedRectangle(cornerRadius: 50, style: .circular))
                            
                            ZStack {
                                Circle()
                                    .frame(width: 152.5, height: 152.5)
                                    .foregroundColor(.white)
                                
                                ZStack {
                                    ProfileImageManager(user: user, size: .extraLarge)
                                }
                            }
                            .background(.white)
                            .clipShape(.circle)
                            .padding(.top, 75)
                        }
                    }
                    
                    ZStack {
                        VStack(spacing: 7.5) {
                            Text(user.username)
                                .font(FontTwo.large)
                                .foregroundColor(authenticationViewModel.blue[0])
                            
                                .kerning(2.5)
                                .offset(x: -3.5, y: 3.5)
                                .overlay {
                                    Text(user.username)
                                        .font(FontTwo.large)                                //                            .foregroundColor(authenticationViewModel.backgroundColor)
                                        .foregroundColor(authenticationViewModel.green[0])
                                        .kerning(2.5)
                                }
                            if let name = user.name {
                                Text(name)
                                    .font(FontSeven.large)
                                    .foregroundColor(Color(.systemGray3))
                                    .offset(x: -3.5, y: 3.5)
                                    .overlay {
                                        Text(name)
                                            .font(FontSeven.large)
                                            .foregroundColor(authenticationViewModel.backgroundColor)
                                    }
                                    .padding(.bottom)
                            }
                            if let profileInformation = user.profileInformation {
                                Text(profileInformation)
                                    .font(FontFour.small)
                                    .padding()
                            }
                            
                            HStack {
                                UserInformation(value: 1, title: "Post")
                                UserInformation(value: 1, title: "Post")
                                
                                Spacer()
                                
                                if user.isCurrentUser {
                                    NavigationLink {
                                        EditScreen(user: user)
                                        
                                    } label: {
                                        Text("Edit Profile")
                                            .padding(12.5)
                                            .background(authenticationViewModel.green[0])
                                            .font(FontOne.small)
                                            .foregroundColor(authenticationViewModel.blue[0])
                                            .foregroundStyle(.ultraThickMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .lineLimit(1)
                                            .padding(.bottom, 250)
                                        
                                    }
                                    .padding(.trailing)
                                }
                            }
                            .padding()
                            
                            Divider()
                            
                            Spacer()
                        }
                    }
                    
                    
                    VStack {
                        PostItemView(user: user.self)
                    }
                }
                .background(LinearGradient(colors: [.clear, .clear, .clear, authenticationViewModel.violet[0].opacity(0.30)], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all))
            }
            .padding()
            
            .tabItem { Image(systemName: "person.circle") }
            
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            
            LocationView()
                .tabItem { Image(systemName: "globe") }
            
            FeedView()
                .tabItem { Image(systemName: "globe") }
            
            PostScreen(post: Post.MOCK_POST[0])
                .tabItem { Image(systemName: "globe.americas") }
            
        }
    }
}
