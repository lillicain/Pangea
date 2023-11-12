//
//  TabScreen.swift
//  Pangea
//
//  Created by Lillian Cain on 11/4/23.
//

import SwiftUI

struct TabScreen: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        TabView {
            
            if let user = authenticationViewModel.currentUser {
                
                ProfileScreen(user: user)
                    .tabItem { Image(systemName: "globe") }
                
                LocationView(post: Post.MOCK_POST[0])
                    .tabItem { Image(systemName: "globe") }
                
                FeedView(post: Post.MOCK_POST[0])
                    .tabItem { Image(systemName: "globe") }
                
            } else {
                loadingScreen
            }
        }
        .accentColor(authenticationViewModel.pink[0])
    }
}

extension TabScreen {
    
    var loadingScreen: some View {
        ZStack {
            LinearGradient(colors: [authenticationViewModel.blue[0], authenticationViewModel.blue[0], authenticationViewModel.violet[0]], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
            
            Image(systemName: "globe")
                .resizable()
                .frame(width: 325, height: 325)
                .offset(x: -15, y: 15)
                .foregroundColor(authenticationViewModel.violet[0])
                .overlay {
                    
                    Image(systemName: "globe")
                        .resizable()
                        .frame(width: 325, height: 325)
                        .foregroundColor(authenticationViewModel.green[0])
                        .shadow(color: .black.opacity(0.25), radius: 1.0, x: 1.0, y: -1.0)
                }
            
        }
    }
}
