//
//  FeedView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/23/23.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @StateObject var feedViewModel = FeedViewModel()
    
    @State var searchText = ""
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 75) {
                ForEach(feedViewModel.posts, id: \.self) { post in
                    FeedScreen(post: post)
                }
            }
            .padding(.top)
        }
        .background(LinearGradient(colors: [.clear, .clear, .clear, authenticationViewModel.violet[0].opacity(0.15)], startPoint: .top, endPoint: .bottom))
        
        .toolbarBackground(.visible, for: .tabBar)
        
//        .toolbarBackground(.linearGradient(colors: [authenticationViewModel.pink[0].opacity(0.15), authenticationViewModel.pink[0].opacity(0.5), .clear], startPoint: .leading, endPoint: .center), for: .tabBar)
        
        .toolbarBackground(.ultraThinMaterial.opacity(0.05), for: .tabBar)
    
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink {
                    SearchScreen()
                } label: {
                    Text("Search")
                }
            }
        }
    }
}

#Preview {
    FeedView()
}
