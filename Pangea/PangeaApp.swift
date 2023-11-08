//
//  PangeaApp.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI
import FirebaseCore
import NavigationRouter

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct PangeaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @NavRouter var navRouter
    
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            
            Group {
                if authenticationViewModel.userSession == nil {
                    NavigationRouter {
                        PangeaView()
                            .navigatesTo(SignInView.self)
                            .navigatesTo(SignUpView.self)
                    }
                } else {
                    TabScreen()
                        .modifier(DarkModeViewModifier())
                }
            }
            .environmentObject(authenticationViewModel)
        }
    }
}
