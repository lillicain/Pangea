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
                    .tabItem { Image("globe") }
                
                LocationView(post: Post.MOCK_POST[0])
                        .tabItem { Image(systemName: "globe") }
                    
                    FeedView(post: Post.MOCK_POST[0])
                        .tabItem { Image(systemName: "globe") }
                    
                } else {
                    loadingScreen
            }
        }
        .accentColor(authenticationViewModel.pink[0])
        .background(LinearGradient(colors: [.clear, .clear, authenticationViewModel.violet[0].opacity(0.15)], startPoint: .bottomLeading, endPoint: .bottomTrailing))
        .ignoresSafeArea(.all)
    }
}

extension TabScreen {
    
    var loadingScreen: some View {
        ZStack {
            LinearGradient(colors: [authenticationViewModel.blue[0], authenticationViewModel.violet[0]], startPoint: .center, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
            
            Image(systemName: "globe")
                .resizable()
                .frame(width: 345, height: 345)
                .offset(x: -5, y: 5)
                .foregroundColor(authenticationViewModel.green[0])
                .overlay {
                    Image(systemName: "globe")
                        .resizable()
                        .frame(width: 342.5, height: 342.5)
                        .foregroundColor(authenticationViewModel.violet[0])
                        .shadow(color: .black.opacity(0.25), radius: 1.5, x: 1.5, y: -1.5)
                }
        }
    }
}
