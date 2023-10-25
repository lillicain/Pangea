//
//  SignInView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        ZStack {
//            LinearGradient(colors: [.black, .white], startPoint: .top, endPoint: .bottomTrailing)
//                .ignoresSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Sign In".uppercased())
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .padding(2.5)
                
                Text("Sign in to your account".uppercased())
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .font(.system(size: 15))
                    .padding(2.5)
                
                Divider()
               
                VStack(spacing: 0) {
                    TextField("Enter Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .modifier(MaterialViewModifier())
                    
                    TextField("Enter Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .modifier(MaterialViewModifier())
                    
                    SecureField("Enter Passsword", text: $password)
                        .modifier(MaterialViewModifier())
                }
                .fontWeight(.bold)
                .font(.system(size: 17.5))
                .padding(.bottom)
                
                Divider()
                    .padding(5)
                
                Text("By signing up you accept the **Terms of Service** and **Privacy Policy**")
                    .padding(.leading, 15)
                    .font(.system(size: 12.5))
                   
                
                Button {
                    Task {
                        try await authenticationViewModel.signIn(withEmail: email, password: password)
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
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Don't have an Account? **Sign Up** ")
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
    SignInView()
}

extension SignInView: AuthenticationProtocol {
    var isValid: Bool {
        return !username.isEmpty
        && !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 6
    }
}
