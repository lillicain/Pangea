//
//  SignUpView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI
import NavigationRouter

struct SignUpView: View {
    @NavRouter var navRouter
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Sign Up".uppercased())
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(2.5)
                
                Text("Create An Account".capitalized)
                    .fontWeight(.semibold)
                    .padding(2.5)
                
                Divider()
                
                VStack(spacing: 0) {
                    TextField("Enter Username", text: $username)
                        .modifier(MaterialViewModifier())
                    
                    TextField("Enter Email", text: $email)
                        .autocapitalization(.none)
                        .modifier(MaterialViewModifier())
                    
                    SecureField("Enter Password", text: $password)
                        .modifier(MaterialViewModifier())
                    
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
                    .font(.system(size: 12.5))
                
                Button {
                    if authenticationViewModel.currentUser != nil {
                        navRouter.push(Screen(user: authenticationViewModel.currentUser ?? User.MOCK_USER[0]))
                    }
                    Task {
                        try await authenticationViewModel.createUser(email: email, username: username, password: password)
                        
                    }
                    
                } label: {
                    HStack {
                        Text("Sign Up".uppercased())
                            .frame(maxWidth: .infinity)
                            .frame(height: 35)
                            .fontWeight(.semibold)
                            .font(.system(size: 25))
                            .padding(5)
                            .modifier(MaterialViewModifier())
                            .padding(.bottom, 5)
                    }
                }
                .padding(5)
                .disabled(!isValid)
                .opacity(isValid ? 1.0 : 0.5)
                .cornerRadius(5)
                
                NavigationLink {
                    SignInView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Already have an Account? **Sign In** ")
                        .padding(.leading, 15)
                        .font(.system(size: 15))
                        .padding(.bottom, 5)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .foregroundColor(Color(.systemGray3))
            .foregroundStyle(.ultraThinMaterial)
            .cornerRadius(15)
            .padding(25)
        }
    }
}

#Preview {
    SignUpView()
}

extension SignUpView: AuthenticationProtocol {
    var isValid: Bool {
        return !username.isEmpty
        && !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 6
        && confirmPassword == password
    }
}
