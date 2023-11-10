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
        VStack(alignment: .trailing, spacing: 15) {
            postImage
            
            
            //                postControl
            
            HStack {
                VStack(alignment: .leading) {
                    
                    Text(post.location)
                        .font(FontOne.extraSmall)
                    
                    Text("\(post.timestamp.dateValue())")
                    
                    
                    Text("\(post.description)")
                    
                    
                    
                    
                }
                Spacer()
                
                
            }
            postUser
                .modifier(ButtonViewModifier())
        }
        .padding()
    }
}

extension FeedScreen {
    var postUser: some View {
        ZStack {
            HStack {
                if let user = post.user {
              
                    NavigationLink(destination: Screen(user: user)) {
                        
                        ProfileImageManager(user: user, size: .extraSmall)
//                        
                        Text(user.username)
                            .font(FontNine.extraSmall)
//                        
                    }
//                    .navigationDestination(for: User.self, destination: { user in
//                        Screen(user: user)
//                    })
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
                            
                            LocationView(post: post)
                        
                            
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
