////
////  AppView.swift
////  Pangea
////
////  Created by Lillian Cain on 11/1/23.
////
//
//import SwiftUI
//
//struct AppView: View {
//    @StateObject var serviceManager = ServiceManager()
//    @StateObject var authenticationViewModel = AuthenticationViewModel()
//    
//    var body: some View {
//        Group {
//            if serviceManager.userSession == nil {
//                PangeaView()
//                
//            } else {
//                Screen()
//            }
//        }
//    }
//}
//
//#Preview {
//    AppView()
//}
