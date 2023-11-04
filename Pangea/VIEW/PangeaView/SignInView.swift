//
//  SignInView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import SwiftUI
import NavigationRouter

struct SignInView: View {
    @NavRouter var navRouter
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [authenticationViewModel.blue[0], authenticationViewModel.violet[0], authenticationViewModel.blue[0], authenticationViewModel.green[0]], startPoint: .top, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Sign In")
                    .font(FontOne.large)
                    .padding(5)
                    .padding(.top)
                
                Text("Sign in to your account".uppercased())
                    .fontWeight(.semibold)
                    .font(.system(size: 15))
                    .padding(5)
                
                Divider()
                
                VStack(spacing: 0) {
                    TextField("Enter Username", text: $username)                        .modifier(MaterialViewModifier())
                    
                    TextField("Enter Email", text: $email)
                        .modifier(MaterialViewModifier())
                    
                    SecureField("Enter Passsword", text: $password)
                        .modifier(MaterialViewModifier())
                }
                
                Divider()
                Text("By signing up you accept the **Terms of Service** and **Privacy Policy**")
                    .padding(.leading, 15)
                    .font(.system(size: 12.5))
                
                
                Button {
                    if let user = authenticationViewModel.currentUser {
                        navRouter.push(Screen(user: user))
                    }
                    
                    Task {
                        do {
                            try await authenticationViewModel.signIn(withEmail: email, password: password)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                } label: {
                    HStack {
                        Text("Sign In")
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
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Don't have an account? **Sign Up** ")
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
