//
//  Screen.swift
//  Pangea
//
//  Created by Lillian Cain on 10/24/23.
//

import SwiftUI
import MapKit

struct Screen: View {
    
    @State var showScreen = false
    
    let user: User
    
    var body: some View {
        TabView {
            ScrollView {
                ZStack {
                    
                    AuthenticationViewModel().backgroundColor.ignoresSafeArea(.all)
                    
                    VStack {
                        MapScreen()
                        
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
                .modifier(DarkModeViewModifier())
                
                ZStack {
                    VStack(spacing: 7.5) {
                        
                        Text(user.username)
                            .font(FontFour.large)
                            .foregroundColor(Color(.systemGray5))
                            .kerning(1.5)
                            .overlay {
                                Text(user.username)
                                    .scaledToFill()
                                    .font(FontFour.large)
                                
                                
                                
                            }
                        
                        if let name = user.name {
                            Text(name)
                            
                                .font(FontFour.small)
                        }
                        if let profileInformation = user.profileInformation {
                            Text(profileInformation)
                            
                                .font(FontFour.small)
                            
                        }
                        
                        HStack {
                            UserInformation(value: 1, title: "Post")
                            UserInformation(value: 1, title: "Post")
                            
                            
                            Spacer()
                            
                            NavigationLink {
                                EditScreen(user: user)
                                
                            } label: {
                                Text(user.isCurrentUser ? "Add Friend" : "Edit Profile")
                                    .padding(7.5)
                                    .background(user.isCurrentUser ? Color(.systemGray3) : Color(.systemGreen))
                                    .font(FontFour.small)
                                    .foregroundStyle(.ultraThickMaterial)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
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
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            
            MapScreen()
                .tabItem { Image(systemName: "globe") }
            MapView()
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



