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
                    .tag([0])
                    .tabItem { Image("globe") }

            }
            
            
            LocationView()
                .tag([1])
                .tabItem { Image(systemName: "globe")}
            
            
            AllFeedView(post: Post.MOCK_POST[0])
                .tag([2])
                .tabItem { Image(systemName: "globe") }
        }
     
        .toolbarBackground(.ultraThinMaterial.opacity(0.05), for: .tabBar)
        
        .accentColor(authenticationViewModel.pink[0])
    }
}
