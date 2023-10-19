//
//  SignUpView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI

struct SignUpView: View {
    
    @State var email = ""
    @State var username = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.black, .white], startPoint: .top, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Sign Up".uppercased())
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                
                Text("Create An Account".capitalized)
                    .fontWeight(.semibold)
                    .padding()
                
                Divider()
                
                VStack(spacing: 0) {
                    TextField("Enter Username", text: $username)
                        .modifier(MaterialViewModifier())
                    TextField("Enter Email", text: $email)
                        .modifier(MaterialViewModifier())
                    SecureField("Enter Password", text: $password)
                        .modifier(MaterialViewModifier())
                    
                    ZStack {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .modifier(MaterialViewModifier())
                        
                        if password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                self.foregroundColor(.green)
                            } else {
                                self.foregroundColor(.red)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}

struct MaterialViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(height: 75)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.25), radius: 2.5, x: 0.5, y: 0.5)
            .padding()
    }
}

