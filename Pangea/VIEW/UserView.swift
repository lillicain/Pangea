//
//  UserView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct UserView: View {
    @AppStorage("appearance") var appearance: Bool = false
    @AppStorage("backgroundColors") var backgroundColors: String = ""
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State var username = ""
    @State var size: CGFloat = 17.5
    @State var backgroundColor: Color = .secondary
    
    @State var hexColorSelected = ["ed4519", "8c00ff","ff0000","0000ff", "ff8300","ffff00", "2d00f7", "89fc00","f20089","ff006e", "a4f603", "C1FF00", "000000", "FFA617", "DD1F9F", "990DCE","243838", "B2FA63", "FF7833", "B2A1FF", "F3EDE1", "F85D32", "FC72AB", "D6D8F1", "19736B", "F4A44E", "455054", "308695", "D45769", "E69D45", "D4CFC9", "F2BB13", "442F73", "F2C2DC", "F26C1F", "FB2850", "FF006E", "80B918", "DDDF00", "F38375", "A5BE00", "1E96FC", "D264B6", "FF499E", "89FC00", "00E9D8", "F20089", "7014F2", "FF0000"]
    
    var body: some View {
        ZStack {
            TabView {
                VStack {
                    Form {
                        Section {
                            profileInformation
                        }
                        Section {
                            locationInformation
                        }
                        Section {
                            colorInformation
                                .padding(.all, 5)
                        }
                        Section {
                            appearanceInformation
                        }
                        Section {
                            userInformation
                        }
                        
                    }
                    .background(backgroundColor)
                    .scrollContentBackground(.hidden)
                }
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .tabItem { Image(systemName: "house") }
                
                MapView()
                    .tabItem { Image(systemName: "globe") }
                
                PostView()
                    .tabItem { Image(systemName: "photo") }
                
                FeedView()
                    .tabItem { Image(systemName: "photo") }
                
                
            }
        }
    }
}

// ???: -

extension UserView {
    
    var profileInformation: some View {
        HStack(alignment: .top) {
            if let user = authenticationViewModel.currentUser {
                ProfileImageManager(user: user, size: .large)
                VStack {
                    Text(user.username)
                        .padding()
                    
                    Text(user.email)
                }
            } else {
                self.opacity(0)
            }
        }
    }
    
    var userInformation: some View {
        VStack(alignment: .leading) {
            if let user = authenticationViewModel.currentUser {
                Text(user.name ?? user.username)
                    .frame(height: 50)
                
                Text(user.email)
                    .frame(height: 35)
            }
            Button {
                AuthenticationViewModel.shared.signOut()
                
                Task {
                    authenticationViewModel.signOut()
                    authenticationViewModel.currentUser = nil
                }
            } label: {
                Text("Sign Out")
                    .font(.headline)
                    .frame(height: 30)
            }
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await authenticationViewModel.deleteAccount()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Delete Account")
                    .font(.headline)
                    .frame(height: 30)
            }
        }
    }
    
    var locationInformation: some View {
        VStack {
            NavigationLink {
                MapViewRepresentable(username: self.username)
                    .ignoresSafeArea(.all)
            } label: {
                Text("\(username)")
            }
            
            LocationButton(.currentLocation) { }
                .cornerRadius(5)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .labelStyle(.titleAndIcon)
                .symbolVariant(.fill)
            
        }
    }
    
    var colorInformation: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(hexColorSelected.hexToColorArray(), id: \.self) { color in
                    Button(action: {
                        backgroundColor = color
                        authenticationViewModel.backgroundColor = color
                        backgroundColors = color.hexString ?? color.ColorToString()
                    }, label: {
                        ZStack {
                            withAnimation(.spring()) {
                                Circle()
                                    .fill(color)
                                    .frame(width: 50, height: 50)
                                    .padding(3.5)
                            }
                        }
                    })
                }
            }
        }
    }
    
    var appearanceInformation: some View {
        VStack {
            Slider(value: $size, in: 15...45)
                .padding(5)
            
            Toggle(appearance ? "Dark Mode" : "Light Mode", isOn: $appearance)
                .padding(3.5)
                .font(.system(size: size))
                .modifier(DarkModeViewModifier())
                .onTapGesture {
                    appearance.toggle()
                }
        }
    }
}


#Preview {
    UserView()
}
