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
        NavigationStack {
            ZStack {
                
                LinearGradient(colors: [authenticationViewModel.blue[0], authenticationViewModel.violet[0]], startPoint: .center, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 350, height: 350)
                    .padding(.bottom, 375)
                    .offset(x: -5, y: 5)
//                    .foregroundColor(.white)
                    .foregroundColor(authenticationViewModel.green[0])
                    .overlay {
                        Image(systemName: "globe")
                            .resizable()
                            .frame(width: 350, height: 350)
                            .padding(.bottom, 375)
                            .foregroundColor(authenticationViewModel.violet[0])
                            .shadow(color: .black.opacity(0.25), radius: 1.5, x: 1.5, y: -1.5)
                    }
        
                VStack(spacing: 75) {
//                        Text("PANGEA")
//                            .font(FontTwo.title)
//                            .scaledToFill()
//                            .foregroundColor(authenticationViewModel.violet[0])
//                            .kerning(3.5)
//                            .offset(x: 2.5, y: -2.5)
//                            .overlay {
                                Text("PANGEA")
                                    .font(FontNine.title)
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                    .kerning(5)
                                    .offset(x: -0.5, y: 0.5)

                                    .overlay {
                                    Text("PANGEA")
                                        .font(FontNine.title)
                                        .scaledToFill()
                                        .foregroundColor(authenticationViewModel.green[0])
                                        .kerning(5)
                                        .shadow(color: .black.opacity(0.25), radius: 1.5, x: 1.5, y: -1.5)
                                       
                                }
//                            }

                        .padding(.top, 375)
                    
                    VStack(spacing: 25) {
                        signUp
                        
                        signIn
                    }
                    .padding()
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
