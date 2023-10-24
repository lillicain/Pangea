//
//  PostItemView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import SwiftUI
import Kingfisher
import MapKit
import CoreLocationUI

struct PostItemView: View {
    @StateObject var postItemViewModel: PostItemViewModel
    
    @StateObject var mapViewModel = MapViewModel()
    
    init(user: User) {
        self._postItemViewModel = StateObject(wrappedValue: PostItemViewModel(user: user))
    }
    
    private let gridItems: [GridItem] = [.init(.flexible(), spacing: 1), .init(.flexible(), spacing: 1)]
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 2) - 1
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 1) {
            ForEach(postItemViewModel.posts) { post in
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageDimension, height: imageDimension)
                    .clipped()
            }
        }
    }
}

struct FeedItemView: View {
    let post: Post
  
    var body: some View {
        VStack {
            ZStack {
                if let user = post.user {
                    NavigationLink(value: user) {
                        ProfileImageManager(user: user, size: .medium)
                        
                        Text(user.username)
                            .fontWeight(.bold)
                    }
                    .navigationDestination(for: User.self, destination: { user in
                        Screen(user: user)
//                        ProfileView(user: user)
//                        FirstView(user: user)
                    })
                }
                Spacer()
            }
            .padding(.leading, 25)
            
            
            KFImage(URL(string: post.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 375, height: 375)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay {
                    if let user = post.user {
                        NavigationLink {
                            MapViewRepresentable(username: user.username)
                                .ignoresSafeArea(.all)
                            
                        } label: {
                            Image(systemName: "mappin.square")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .padding(.leading, 275)
                                .padding(.top, 275)
                        }
                    }
                }
            
            Text("\(post.timestamp.dateValue().formatted(date: .abbreviated, time: .standard))")
                .padding(.all, 5)
            
            Text("\(post.caption)")
                .padding(.all, 5)
            
            Text(post.location?.latitude.description ?? "")
            Text(post.location?.longitude.description ?? "")
    
        }
    }
}
