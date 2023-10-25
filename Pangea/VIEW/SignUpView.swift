//
//  SignUpView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State var email = ""
    @State var username = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.black, .white], startPoint: .top, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
            
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
                        .textInputAutocapitalization(.never)
//                        .modifier(MaterialViewModifier())
                    
                    TextField("Enter Email", text: $email)
                        .textInputAutocapitalization(.never)
//                        .modifier(MaterialViewModifier())
                    
                    SecureField("Enter Password", text: $password)
//                        .modifier(MaterialViewModifier())
                    
                    ZStack(alignment: .trailing) {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .modifier(MaterialViewModifier())
                        
                        if password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle")
                                    .imageScale(.large)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle")
                                    .imageScale(.large)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                }
                
                Divider()
                    .padding(5)
                
                Text("By signing up you accept the **Terms of Service** and **Privacy Policy**")
                    .padding(.leading, 15)
                    .font(.system(size: 15))
                    .padding(.bottom, 5)
                
                Button {
                    Task {
                        try await authenticationViewModel.createUser(email: email, username: username, password: password)
                    }
                    
                } label: {
                    Text("Sign Up".uppercased())
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .fontWeight(.semibold)
                        .font(.system(size: 25))
                        .padding()
                        .modifier(MaterialViewModifier())
                        .padding(.bottom, 5)
                }
                .padding(10)
                
                NavigationLink {
                    SignInView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Already have an Account? **Sign In** ")
                        .font(.system(size: 15))
                }
                
            }
            .padding()
            .background(.ultraThinMaterial)
            .foregroundStyle(.ultraThinMaterial)
            .cornerRadius(15)
            .padding(25)
    
        }
    }
}

#Preview {
    SignUpView()
}
