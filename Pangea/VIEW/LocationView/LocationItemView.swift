//
//  LocationItemView.swift
//  Pangea
//
//  Created by Lillian Cain on 11/19/23.
//

import SwiftUI
import Kingfisher
import MapKit

struct LocationItemView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @ObservedObject var feedViewModel = FeedViewModel()
    
    let post: Post
    
    var body: some View {
        VStack(spacing: -50) {
            postImage
        }
    }
}

extension LocationItemView {
    var postImage: some View {
        KFImage(URL(string: post.imageUrl))
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .clipShape(.circle)
            .overlay {
                if let user = post.user {
                    NavigationLink {
                        ProfileScreen(user: user)
                    } label: {
                        Text(user.username)
                            .font(FontNine.extraSmall)
                    }
                }
            }
    }
}
