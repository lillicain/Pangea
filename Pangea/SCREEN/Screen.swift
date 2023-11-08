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
        ScrollView {
            VStack {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 50, style: .circular)
                        .foregroundColor(authenticationViewModel.blue[0])
                        .frame(width: 412.5, height: 262.5)
                    
                    ZStack {
                        LocationView()
                            .frame(width: 400, height: 250, alignment: .top)
                            .clipShape(RoundedRectangle(cornerRadius: 50, style: .circular))
                            .padding(.bottom)
                    }
                    
                    ZStack {
                        Circle()
                            .frame(width: 182.5, height: 185.5)
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
                .overlay {
                    ZStack {
                        if user.isCurrentUser {
                            NavigationLink {
                                EditScreen(user: user)
                                
                            } label: {
                                Text("Edit Profile")
                                    .modifier(PostViewModifier())
                            }
                            .padding(.leading, 207.5)
                            .padding(.bottom, 235)
                        }
                    }
                }
                
                ZStack {
                    VStack(spacing: 7.5) {
                        Text(user.username)
                            .font(FontEight.title)
                            .foregroundColor(authenticationViewModel.blue[0])
                            .offset(x: -2.5, y: 2.5)
                            .kerning(1.5)
                            .overlay {
                                Text(user.username)
                                    .font(FontEight.title)
                                    .kerning(1.5)
                                    .foregroundColor(authenticationViewModel.green[0])
                            }
                        
                        Text(user.username)
                            .font(FontNine.small)
                            .foregroundColor(authenticationViewModel.blue[0])
                        
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
                        
                        //                        HStack {
                        //                            UserInformation(value: 1, title: "Post")
                        //                                .padding()
                        //                                .padding(.vertical, 50)
                        //
                        //                            Spacer()
                        //
                        
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 5)
                            .padding(.top, 25)
                            .padding(.vertical, 50)
                        
                            .foregroundColor(authenticationViewModel.blue[0])
                        
                        
                        Spacer()
                    }
                }
                
                VStack {
                    PostItemView(user: user.self)
                    
                }
            }
        }
        .background(LinearGradient(colors: [.clear, .clear, .clear, .clear, authenticationViewModel.violet[0].opacity(0.15)], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all))
    }
}
