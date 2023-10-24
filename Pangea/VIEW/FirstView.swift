//
//  FirstView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/23/23.
//

import SwiftUI
import MapKit

struct FirstView: View {
    @State var settings = false
    
    let user: User
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    Map {
                        
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 250)
                    .cornerRadius(50)
                    .padding(.bottom, 50)
                }
                ZStack {
                    ProfileImageManager(user: user, size: .extraLarge)
                    
                }
                .background(.white)
                .clipShape(Circle())
                .padding(.top, 75)
            }
            VStack {
                    Text(user.username)
                    .fontWeight(.bold)
                HStack {
                    Spacer()
                    Button {
                        if user.isCurrentUser {
                            settings.toggle()
                        }
                        
                    } label: {
                        Text(user.isCurrentUser ? "Edit" : "Add Friend")
                            .padding(10)
                            .background(user.isCurrentUser ? .white : Color(.systemGreen))
                            .foregroundStyle(.ultraThickMaterial).fontWeight(.bold)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(user.isCurrentUser ? .white : .clear))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            
                    }
//                    .padding(.bottom)
                    .padding(.trailing)
                    
                    
                }
                .sheet(isPresented: $settings) {
                    EditUserView(user: user)
                }
                .frame(height: 50)
                
            
                }
                if let name = user.name {
                    Text(name)
                }
                if let profileInformation = user.profileInformation {
                    Text(profileInformation)
                }
            
                   
            VStack {
                PostItemView(user: user)
            }
            
        }
    }
}

#Preview {
    FirstView(user: User.MOCK_USER)
}
