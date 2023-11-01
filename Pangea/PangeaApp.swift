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

    
//    init(user: User) {
//        self._editUserViewModel = StateObject(wrappedValue: EditUserViewModel(user: user))
//    }
//    @ObservedObject var editUserViewModel = EditUserViewModel(user: a)
    
    var body: some Scene {
        WindowGroup {
            NavigationRouter {
                Group {
                    if authenticationViewModel.userSession != nil {
//                        let user = authenticationViewModel.currentUser
                            
                        Screen(user: authenticationViewModel.currentUser ?? User.MOCK_USER[0])
                                .modifier(DarkModeViewModifier())
                     
                    } else {
                        PangeaView()
            
                    }
                }
            }
            .environmentObject(authenticationViewModel)

        }
    }
}
