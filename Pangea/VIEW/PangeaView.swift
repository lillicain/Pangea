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
                authenticationViewModel.green[0]
                    .ignoresSafeArea(.all)
             
                VStack(spacing: 25) {
                    Text("PANGEA")
                        .font(FontTwo.title)
                        .foregroundColor(authenticationViewModel.blue[0])

                        .kerning(5)
                        .offset(x: -3.5, y: 3.5)
                        .overlay {
                            Text("PANGEA")
                                .font(FontTwo.title)
                                .foregroundColor(authenticationViewModel.pink[0])
                                .kerning(5)
                        }
                        .padding(25)
                                       
                    VStack {
                        signUp
                    }
                    
                    VStack {
                        signIn
                    }
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
                Text("Sign Up")
                    .font(FontSeven.large)
                    .frame(width: 300, height: 75)
                    .background(authenticationViewModel.blue[0])
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .kerning(2.5)
                    .offset(x: -2.5, y: 2.5)
                    .overlay {
                        Text("Sign Up")
                            .font(FontSeven.large)
                            .foregroundColor(authenticationViewModel.pink[0])
                       
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
                Text("Sign In")
                    .font(FontSeven.large)
                    .frame(width: 300, height: 75)
                    .background(authenticationViewModel.blue[0])
                
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .kerning(2.5)
                    .offset(x: -2.5, y: 2.5)
                    .overlay {
                        Text("Sign In")
                            .font(FontSeven.large)
                            .foregroundColor(authenticationViewModel.pink[0])
                    }
            }
        }
    }
}
