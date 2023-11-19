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
    
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var feedViewModel = FeedViewModel()
    
    let post: Post
    
//    let location: CLLocationCoordinate2D
    
    var body: some View {
        ZStack {
            postImage
            
        }
    }
}

extension LocationItemView {
    var postImage: some View {
        KFImage(URL(string: post.imageUrl))
            .resizable()
            .scaledToFill()
            .frame(width: 375, height: 500)
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
