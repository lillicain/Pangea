//
//  Screen.swift
//  Pangea
//
//  Created by Lillian Cain on 10/24/23.
//

import SwiftUI
import MapKit

struct Screen: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var editUserViewModel: EditUserViewModel
    
    @State var showScreen = false
    
    let user: User
    
    var body: some View {
        TabView {
            ScrollView {
                VStack {
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 50, style: .circular)
                            .foregroundColor(authenticationViewModel.blue[0])
                            .frame(width: 412.5, height: 260)
                        //                            .padding(.bottom, 50)
                        
                        
                        ZStack {
                            LocationView()
                                .frame(width: 400, height: 250, alignment: .top)
                            
                                .clipShape(RoundedRectangle(cornerRadius: 50, style: .circular))
                        }
                        
                        
                        ZStack {
                            Circle()
                                .frame(width: 155, height: 155)
                                .foregroundColor(.white)
                                .padding(.top, 100)
                            
                            ZStack {
                                ProfileImageManager(user: user, size: .extraLarge)
                            }
                        }
                        .background(.white)
                        .clipShape(.circle)
                        .padding(.top, 75)
                        
                    }
                    
                    ZStack {
                        VStack(spacing: 7.5) {
                            Text(user.username)
                                .font(FontOne.title)
                                .foregroundColor(authenticationViewModel.blue[0])
                             
                                .offset(x: -1.5, y: 1.5)
                                .kerning(1.5)
                                .overlay {
                                    Text(user.username)
                                        .font(FontOne.title)
                                        .kerning(1.25)
                                        .foregroundColor(authenticationViewModel.green[0])
                                    
                                }
                            if let name = user.name {
                                Text(name)
                                    .font(FontSeven.large)
                                    .foregroundColor(Color(.systemGray3))
                                    .offset(x: -3.5, y: 3.5)
                                    .overlay {
                                        Text(name)
                                            .font(FontSeven.large)
                                            .foregroundColor(authenticationViewModel.backgroundColor)
                                    }
                                    .padding(.bottom)
                            }
                            if let profileInformation = user.profileInformation {
                                Text(profileInformation)
                                    .font(FontFour.small)
                                    .padding()
                            }
                            
                            HStack {
                                //                                UserInformation(value: 1, title: "Post")
                                //                                UserInformation(value: 1, title: "Post")
                                
                                Spacer()
                                
                                if user.isCurrentUser {
                                    NavigationLink {
                                        EditScreen(user: user)
                                        
                                    } label: {
//                                        RoundedRectangle(cornerRadius: 25, style: .circular)
//                                            .foregroundColor(authenticationViewModel.green[0])
//                                            .frame(width: 175, height: 57.5)
//                                            .padding(.bottom, 250)
//                                            .overlay {
                                                Text("Edit Profile")
                                            .modifier(PostViewModifier())
//                                                    .padding(12.5)
//                                                    .background(.white)
//                                                    .font(FontOne.small)
//                                                    .foregroundColor(authenticationViewModel.blue[0])
//                                                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .circular))
//                                                    .padding(.bottom, 250)
//                                            }
                                    }
                                    .padding(.trailing)
                                }
                            }
                            .padding()
                            
                            Divider()
                            
                            Spacer()
                        }
                    }
                    
                    
                    VStack {
                        PostItemView(user: user.self)
                    }
                }
            }
            
            .background(LinearGradient(colors: [.clear, .clear, .clear, .clear, authenticationViewModel.violet[0].opacity(0.15)], startPoint: .top, endPoint: .bottom))
          
            .toolbarBackground(.ultraThinMaterial.opacity(0.05), for: .tabBar)
            .toolbarBackground(.ultraThinMaterial.opacity(0.05), for: .navigationBar)
            
            .tabItem { Image(systemName: "person.circle") }
            
            LocationView()
                .tabItem { Image(systemName: "mappin.and.ellipse.circle.fill") }
       
            AllFeedView(post: Post.MOCK_POST[0])
                .tabItem { Image(systemName: "globe.americas") }
            
        }
        .accentColor(authenticationViewModel.blue[0])
    }
}
