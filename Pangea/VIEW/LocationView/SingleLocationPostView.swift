////
////  SingleLocationPostView.swift
////  Pangea
////
////  Created by Lillian Cain on 11/13/23.
////
//
//import SwiftUI
//import Kingfisher
//import CoreLocation
//import CoreLocationUI
//import MapKit
//
//struct SingleLocationPostView: View {
//
//    let post: Post
//
//    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
//
//    @StateObject var singleLocationPostViewModel = SingleLocationPostViewModel()
//
//    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
//    @State var results = [MKMapItem]()
//    @State var visibleRegion: MKCoordinateRegion?
//    @State var username = ""
//
//    var body: some View {
//        VStack {
//            Map(position: $cameraPosition) {
//                UserAnnotation()
//
//                Annotation("Home", coordinate: .homeLocation) {
//                    homeAnnotation
//                }
//
//                Annotation("Post", coordinate: CLLocationCoordinate2D(latitude: singleLocationPostViewModel.latLong.0, longitude: singleLocationPostViewModel.latLong.1)) {
//                    KFImage(URL(string: post.imageUrl))
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 70, height: 70)
//                        .clipShape(.circle)
//                        .offset(x: 250)
//                }
//            }
//            .mapStyle(.standard(elevation: .realistic))
//            .safeAreaPadding(.top, 25)
//            .safeAreaPadding(.trailing, 5)
//            .mapControls {
//                MapInformation()
//            }
//            .safeAreaInset(edge: .bottom) {
//                VStack {
//                    MapItemView(cameraPosition: $cameraPosition, results: $results, visibleRegion: $visibleRegion, username: $username)
//                        .padding(.leading, 315)
//                        .padding(.bottom, 50)
//                }
//            }
//            .frame(width: 375, height: 625)
//            .cornerRadius(50)
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 65, style: .circular)
//                    .foregroundColor(authenticationViewModel.blue[0])
//                    .frame(width: 405, height: 650)
//            )
//            .task {
//                await singleLocationPostViewModel.getCoordinates(post: post)
//            }
//        }
//    }
//}
//
//extension SingleLocationPostView {
//
//    var homeAnnotation: some View {
//        ZStack {
//            Circle()
//                .frame(width: 50, height: 50)
//                .foregroundColor(.white)
//            Circle()
//                .frame(width: 45, height: 45)
//                .foregroundColor(authenticationViewModel.pink[0])
//            Image(systemName: "house")
//                .foregroundColor(.white)
//        }
//    }
//}
