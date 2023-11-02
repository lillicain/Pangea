//
//  PangeaApp.swift
//  Pangea
//
//  Created by Lillian Cain on 10/19/23.
//

import SwiftUI
import FirebaseCore
import NavigationRouter
import FirebaseFirestore
import FirebaseFirestoreSwift

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
    
//    @StateObject var serviceManager = ServiceManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationRouter {
                Group {
                    
                    if authenticationViewModel.userSession == nil {
                        PangeaView()
                      
                    } else {
                       
                        Screen()
//                            .modifier(DarkModeViewModifier())
                        
                        
                        
//                    if authenticationViewModel.userSession == nil {
//                        PangeaView()
//                     
//                     
//                    } else {
//                      
//                        Screen()
//                            .modifier(DarkModeViewModifier())
                        
//                        PangeaView()
//                        
//                        if let user = authenticationViewModel.currentUser {
//                            Screen(user: user)
//                            
//                        } else {
//                            Screen(user: authenticationViewModel.currentUser ?? User.MOCK_USER[0])
//                                .modifier(DarkModeViewModifier())
//                        }
                    }
                }
            }
            .environmentObject(authenticationViewModel)
        }
    }
}
