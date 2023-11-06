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
                Screen(user: user)
                    .tabItem { Image("globe") }
            }
            
            LocationView()
                .tabItem { Image(systemName: "globe") }
            
        
            
            AllFeedView(post: Post.MOCK_POST[0])
                .tabItem { Image(systemName: "globe") }
        }
        .accentColor(authenticationViewModel.pink[0])
    }
}
