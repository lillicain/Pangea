//
//  PangeaView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/31/23.
//

import SwiftUI

struct PangeaView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
            ZStack {
                
                LinearGradient(colors: [authenticationViewModel.blue[0], authenticationViewModel.violet[0]], startPoint: .center, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 345, height: 345)
                    .padding(.bottom, 395)
                    .offset(x: -5, y: 5)
                    .foregroundColor(authenticationViewModel.green[0])
                    .overlay {
                        Image(systemName: "globe")
                            .resizable()
                            .frame(width: 342.5, height: 342.5)
                            .padding(.bottom, 395)
                            .foregroundColor(authenticationViewModel.violet[0])
                            .shadow(color: .black.opacity(0.25), radius: 1.5, x: 1.5, y: -1.5)
                    }
                
                VStack(spacing: 100) {
                    Text("PANGEA")
                        .font(FontNine.title)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                        .kerning(2.5)
                        .offset(x: -1.5, y: 1.5)
                        .overlay {
                            Text("PANGEA")
                                .font(FontNine.title)
                                .scaledToFit()
                                .foregroundColor(authenticationViewModel.green[0])
                                .kerning(2.5)
                                .shadow(color: .black.opacity(0.25), radius: 1.5, x: 1.5, y: -1.5)
                                .shadow(color: .white.opacity(0.25), radius: 1.5, x: -1.5, y: 1.5)
                        }
                        .padding(.top, 375)
                    
                    
                    VStack {
                        signUp
                        signIn
                    }
                }
                ZStack {
                    Text("Reconnect")
                        .font(FontFour.small)
                        .padding(.top, 165)
                        .kerning(7.5)
                        .foregroundColor(.white.opacity(0.75))
                        .offset(x: -1.5, y: 1.5)
                        .padding(.leading, 175)
                        .overlay {
                            Text("Reconnect")
                                .font(FontFour.small)
                                .padding(.top, 165)
                                .kerning(7.5)
                                .foregroundColor(authenticationViewModel.pink[0])
                            
                                .shadow(color: .white.opacity(0.25), radius: 0.5, x: -0.5, y: 0.5)
                                .padding(.leading, 175)
                        }
                }
            }
        }
    }

#Preview {
    PangeaView()
}

extension PangeaView {
    var signUp: some View {
        ZStack {
            NavigationLink {
                SignUpView()
                    .navigationBarBackButtonHidden(true)
                
            } label: {
                withAnimation(.smooth) {
                    Text("Sign Up")
                        .font(FontOne.body)
                        .foregroundColor(.white)
                        .modifier(ButtonViewModifier())
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .kerning(1.5)
                        .offset(x: 0.5, y: 0.5)
                        .overlay {
                            Text("Sign Up")
                                .font(FontOne.body)
                                .kerning(1.5)
                                .foregroundColor(authenticationViewModel.green[0])
                                .shadow(color: .black.opacity(0.25), radius: 1.5, x: 1.5, y: -1.5)
                        }
                    
                }
            }
        }
    }
    
    var signIn: some View {
        ZStack {
            NavigationLink {
                SignInView()
                    .navigationBarBackButtonHidden(true)
                
            } label: {
                withAnimation(.smooth) {
                    Text("Sign In")
                        .font(FontOne.body)
                        .foregroundColor(.white)
                        .modifier(ButtonViewModifier())
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .kerning(1.5)
                        .offset(x: 0.5, y: 0.5)
                        .overlay {
                            Text("Sign In")
                                .font(FontOne.body)
                                .kerning(1.5)
                                .foregroundColor(authenticationViewModel.green[0])
                                .shadow(color: .black.opacity(0.25), radius: 1.5, x: 1.5, y: -1.5)
                        }
                }
            }
        }
    }
}
