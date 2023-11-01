//
//  AppView.swift
//  Pangea
//
//  Created by Lillian Cain on 11/1/23.
//

import SwiftUI
import NavigationRouter

struct AppView: View {
    
    @NavRouter var navRouter
    
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        Group {
//            NavigationRouter {
//                
//            }
        }
    }
}

#Preview {
    AppView()
}
