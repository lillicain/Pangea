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
            TabView {
                Group {
                    if authenticationViewModel.userSession == nil {
                        PangeaView()
                        
                    } else {
                        //                        Screen(user: authenticationViewModel.currentUser ?? User.MOCK_USER[0])
                        TabScreen()
//                        if let user = authenticationViewModel.currentUser {
//                            
//                            
//                            Screen(user: user)
//                                .modifier(DarkModeViewModifier())
//                        } else {
//                            PangeaView()
//                        }
                        
                    }
                }
            }
            .environmentObject(authenticationViewModel)
        }
    }
}
