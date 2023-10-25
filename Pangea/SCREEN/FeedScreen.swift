//
//  FeedScreen.swift
//  Pangea
//
//  Created by Lillian Cain on 10/24/23.
//

import SwiftUI
import Kingfisher

struct FeedScreen: View {
    let post: Post
  
    var body: some View {
        VStack {
            HStack {
                    if let user = post.user {
                        NavigationLink(value: user) {
                            ProfileImageManager(user: user, size: .small)
                            
                            Text(user.username)
                                .fontWeight(.bold)
                        }
                   
                
                        .navigationDestination(for: User.self, destination: { user in
                            Screen(user: user)
                        })
                        .frame(alignment: .leading)
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
                            
//                            MapViewRepresentable(username: user.username)
//                                .ignoresSafeArea(.all)
                            
                        } label: {
                            Image(systemName: "mappin.and.ellipse.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 75, height: 75)
                                .padding(.leading, 275)
                                .padding(.top, 275)
                        }
                    }
                }
            
            HStack(spacing: 15) {
                Button {
                    
                } label: {
                    Image(systemName: "heart")
                        .imageScale(.large)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "network")
                        .imageScale(.large)
                }
                
                Spacer()
            }
            .padding(.leading)
            .padding()
            
            Text("\(post.timestamp.dateValue().formatted(date: .complete, time: .standard))")
                .padding(.all, 5)
            
            Text("\(post.caption)")
                .padding(.all, 5)
          
            
        }
    }
}
