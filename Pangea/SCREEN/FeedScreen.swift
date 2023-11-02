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
                    
                    NavigationLink {
                        LocationView()
                        
                    } label: {
                        Image(systemName: "mappin.and.ellipse.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 100, height: 100)
                            .offset(x: 1.5, y: -1.5)
                            .overlay {
                                Image(systemName: "mappin.and.ellipse.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(authenticationViewModel.green[0])
                                    .frame(width: 100, height: 100)
                                   
                            }
                            .padding(.leading, 250)
                            .padding(.top, 250)
                            
                    }
                    .padding()
                }
            
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
            .padding(.leading)
            .padding()
            
//            Text("\(post.timestamp.dateValue().formatted(date: .complete, time: .standard))")
            
            Text("\(post.timestamp.dateValue())")
                .padding(.all, 5)
            
            Text("\(post.caption)")
                .padding(.all, 5)
            
            Text(post.location)
                .padding(.all, 5)
            
          
        }
    }
}
