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
                    VStack {
                        Map {
                            
                        }
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
                VStack(spacing: 7.5) {
                    Text(user.username)
                        .fontWeight(.bold)
                    
                    if let name = user.name {
                        Text(name)
                    }
                    if let profileInformation = user.profileInformation {
                        Text(profileInformation)
                    }
                    HStack {
                        Spacer()
                        
                        Button {
                            if user.isCurrentUser {
                                showScreen.toggle()
                            }
                        } label: {
                            Text(user.isCurrentUser ? "Edit Profile" : "Add Friend")
                                .padding(7.5)
                                .background(user.isCurrentUser ? Color(.systemGray3) : Color(.systemGreen))
                                .foregroundStyle(.ultraThickMaterial)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .padding(.bottom, 250)
                        }
                        .padding(.bottom, 25)
                        .padding(.trailing)
                    }
                    .sheet(isPresented: $showScreen) {
                        EditScreen(user: user)
                    }
                    
                }
                Divider()
                
                VStack {
                    PostItemView(user: user)
                }
            }
            .tabItem { Image(systemName: "person.fill") }
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            
            FeedView()
                .tabItem { Image(systemName: "globe") }
            
            PostScreen()
                .tabItem { Image(systemName: "globe") }
            
            
        }
   
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    EditScreen(user: user)
                } label: {
                    Text("Edit")
                }
            }
        }
    }
}

#Preview {
    Screen(user: User.MOCK_USER[0])
}



