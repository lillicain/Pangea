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
                
            }
        }
        .accentColor(authenticationViewModel.pink[0])
        .background(LinearGradient(colors: [.clear, .clear, authenticationViewModel.violet[0].opacity(0.15)], startPoint: .bottomLeading, endPoint: .bottomTrailing))
        .ignoresSafeArea(.all)
    }
}
