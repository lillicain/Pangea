////
////  FeedView.swift
////  Pangea
////
////  Created by Lillian Cain on 10/23/23.
////
//
//import SwiftUI
//import PhotosUI
//import AVKit
//import CoreLocationUI
//
//struct FeedView: View {
//    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
//    
//    @StateObject var feedViewModel = FeedViewModel()
//    
//    @State var searchText = ""
//    @State var newPost = false
//    
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 75) {
//                ForEach(feedViewModel.posts, id: \.self) { post in
//                    FeedScreen(post: post)
//                }
//            }
//            .padding(.top)
//        }
//        .sheet(isPresented: $newPost, content: {
//            PostScreen(post: Post.MOCK_POST[0])
//                .presentationDetents([.height(700)])
//                .presentationCornerRadius(50)
//        })
//        
//        .background(LinearGradient(colors: [.clear, .clear, .clear, authenticationViewModel.violet[0].opacity(0.15)], startPoint: .top, endPoint: .bottom))
//        
//        .toolbarBackground(.visible, for: .tabBar)
//        .toolbarBackground(.ultraThinMaterial.opacity(0.5), for: .tabBar)
//        
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                NavigationLink {
//                    SearchScreen()
//                } label: {
//                    Text("Search")
//                }
//            }
//            
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    newPost.toggle()
//                    
//                } label: {
//                    Text("Post")
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    FeedView()
//}
