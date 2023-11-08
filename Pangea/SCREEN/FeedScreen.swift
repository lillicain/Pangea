//
//  FeedScreen.swift
//  Pangea
//
//  Created by Lillian Cain on 10/24/23.
//

import SwiftUI
import Kingfisher

struct FeedScreen: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
 
    let post: Post
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .trailing, spacing: 15) {
                postImage
                postUser
                postControl
                
                HStack {
                    VStack {
                        Text("\(post.timestamp.dateValue())")
                    
                        
                        Text("\(post.description)")
                        
                        
                        Text(post.location)
                        
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }
}

extension FeedScreen {
    var postUser: some View {
        ZStack {
            HStack {
                if let user = post.user {
                    NavigationLink(value: user) {
                        ProfileImageManager(user: user, size: .extraSmall)
                        
                        Text(user.username)
                            .fontWeight(.bold)
                    }
                    .navigationDestination(for: User.self, destination: { user in
                        Screen(user: user)
                    })
                }
                Spacer()
            }
        }
    }
    
    var postImage: some View {
        ZStack {
            KFImage(URL(string: post.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 375, height: 500)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay {
                    
                    NavigationLink {
                        LocationView(post: Post.MOCK_POST[0])
                        
                    } label: {
                        Image(systemName: "mappin.and.ellipse.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(authenticationViewModel.blue[0])
                            .frame(width: 100, height: 100)
                            .offset(x: 1.5, y: -1.5)
                            .shadow(color: .white.opacity(0.05), radius: 0.5, x: 0.5, y: -0.5)
                            .overlay {
                                Image(systemName: "mappin.and.ellipse.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(authenticationViewModel.green[0])
                                    .frame(width: 100, height: 100)
                                
                            }
                        
                            .padding(.leading, 225)
                            .padding(.top, 350)
                        
                    }
                }
        }
    }
    
    var postControl: some View {
        ZStack {
            HStack(spacing: 15) {
                Button {
                    
                } label: {
                    withAnimation(.spring()) {
                        Image(systemName: "ladybug")
                            .imageScale(.large)
                    }
                }
                
                Button {
                    
                } label: {
                    withAnimation(.spring()) {
                        Image(systemName: "globe.americas")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .imageScale(.large)
                    }
                }
                Spacer()
                
            }
        }
    }
}
