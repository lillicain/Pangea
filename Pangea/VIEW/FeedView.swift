//
//  FeedView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/23/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var feedViewModel = FeedViewModel()
    @State var searchText = ""
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 75) {
                ForEach(feedViewModel.posts) { post in
                    FeedScreen(post: post)
                }
            }
            .padding(.top)
            .searchable(text: $searchText, prompt: "Search...")
        }
        
        .navigationBarTitleDisplayMode(.inline)
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
