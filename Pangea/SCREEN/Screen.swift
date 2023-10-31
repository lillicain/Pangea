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
    
    @State var showScreen = false
    
    let user: User
    
    var body: some View {
        TabView {
            ScrollView {
                ZStack {
                    
                    VStack {
                        LocationView()
                            .frame(width: UIScreen.main.bounds.width, height: 250)
                            .cornerRadius(50)
                            .padding(.bottom, 50)
                    }
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
                
                
                ZStack {
                    VStack(spacing: 7.5) {
                        Text(user.username)
                            .font(FontTwo.title)
                        
//                            .foregroundColor(Color(.systemGray3))
                        
                            .foregroundStyle(authenticationViewModel.blue[0])
                        
                            .kerning(5)
                            .offset(x: -3.5, y: 3.5)
                            .overlay {
                        Text(user.username)
                            .font(FontTwo.title)
                                
//                            .foregroundColor(authenticationViewModel.backgroundColor)
                                
                            .foregroundColor(authenticationViewModel.green[0])
                                
                            .kerning(5)
    
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
                                
                            
                            NavigationLink {
                                EditScreen(user: user)
                                    
                            } label: {
                                Text(user.isCurrentUser ? "Add Friend" : "Edit Profile")
                                    .padding(12.5)
                                    .background(user.isCurrentUser ? Color(.systemGray3) : authenticationViewModel.green[0])
                                    .font(FontOne.small)
                                    .foregroundColor(authenticationViewModel.blue[0])
                                    .foregroundStyle(.ultraThickMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .lineLimit(1)
                                    .padding(.bottom, 250)
                                
                            }
                            .padding(.trailing)
                            
                        }
                        Divider()
                        
                        Spacer()
                    }
                }
                
                VStack {
                    PostItemView(user: user)
                }
            }
            
            .tabItem { Image(systemName: "person.circle") }
            
//                    .foregroundColor(authenticationViewModel.backgroundColor)
//                    .background(authenticationViewModel.backgroundColor)
            
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            
            MapScreen()
                .tabItem { Image(systemName: "globe") }
            
          LocationView()
                .tabItem { Image(systemName: "globe") }
            
            FeedView()
                .tabItem { Image(systemName: "globe") }
            
            PostScreen()
                .tabItem { Image(systemName: "globe.americas") }
            
        }
    }
}

#Preview {
    Screen(user: User.MOCK_USER[0])
}



