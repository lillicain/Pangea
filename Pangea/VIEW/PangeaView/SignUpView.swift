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
            
            LinearGradient(colors: [authenticationViewModel.blue[0], authenticationViewModel.violet[0], authenticationViewModel.blue[0], authenticationViewModel.pink[0]], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Sign Up")
                    .font(FontOne.large)
                    .padding(5)
                    .padding(.top)
                
                Text("Create An Account".capitalized)
                    .fontWeight(.semibold)
                    .padding(5)
                
                Divider()
                
                VStack(spacing: 0) {
                    TextField("Enter Username", text: $username)
                        .modifier(MaterialViewModifier())
                    
                    TextField("Enter Email", text: $email)
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
                                    .padding(.trailing, 50)
                            } else {
                                Image(systemName: "xmark.circle")
                                    .imageScale(.large)
                                    .foregroundColor(Color(.systemRed))
                                    .padding(.trailing, 50)
                            }
                        }
                    }
                }
                
                Divider()
                
                Text("By signing up you accept the **Terms of Service** and **Privacy Policy**")
                    .padding(.leading, 15)
                    .font(.system(size: 12.5))
                
                Button {
                    
                    Task {
                        do {
                            //                            try await AuthenticationViewModel.shared.createUser(email: email, username: username, password: password)
                            if let user = authenticationViewModel.currentUser {
                                navRouter.push(Screen(user: user))
                            }

                            try await authenticationViewModel.createUser(email: email, username: username, password: password)
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                } label: {
                    HStack {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .frame(height: 35)
                            .font(FontOne.small)
                            .padding(5)
                            .modifier(MaterialViewModifier())
                            .padding(.bottom, 5)
                    }
                }
                .padding(5)
                .disabled(!isValid)
                .opacity(isValid ? 1.0 : 0.5)
                .cornerRadius(15)
                
                NavigationLink {
                    SignInView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Already have an account? **Sign In** ")
                        .padding(.leading, 15)
                        .font(.system(size: 15))
                        .padding(.bottom)
                }
            }
            .padding()
            .background(.ultraThinMaterial.opacity(0.75))
            .foregroundColor(.white)
            .foregroundStyle(.ultraThinMaterial)
            .cornerRadius(50)
            .padding(25)
        }
    }
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
