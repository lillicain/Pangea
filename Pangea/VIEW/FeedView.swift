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
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 100) {
                    ForEach(feedViewModel.posts) { post in
                        FeedItemView(post: post)
                    }
                }
                .padding(.top)
                .searchable(text: $searchText, prompt: "Search...")
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
//                        PostView()
                    } label: {
                        Text("Post")
                    }
                }
            }
        }
    }
}


#Preview {
    FeedView()
}
