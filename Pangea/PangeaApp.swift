//
//  PangeaApp.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI
import FirebaseCore

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
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Group {
                    if authenticationViewModel.userSession == nil {
                        SignUpView()
                    } else {
                        UserView()
                    }
                }
            }
            .environmentObject(authenticationViewModel)
        }
    }
}
