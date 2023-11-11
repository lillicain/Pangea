//
//  LocationView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/31/23.
//

import SwiftUI
import MapKit
import CoreLocationUI
import CoreLocation
import Kingfisher

struct LocationView: View {
    
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    @ObservedObject var feedViewModel = FeedViewModel()
    
    @ObservedObject var locationManager = LocationManager()
    
    @State var selectedPost: MKMapItem?
    
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var searchText = ""
    @State var results = [MKMapItem]()
    @State var selectedResult: MKMapItem?
    @State var showDetails = false
    @State var getDirections = false
    @State var routeDisplaying = false
    @State var route: MKRoute?
    @State var routeDestination: MKMapItem?
    @State var username = ""
    @State var visibleRegion: MKCoordinateRegion?
    @State var isSelected = false
    @State var lookAroundScene: MKLookAroundScene?
    
    let post: Post
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Map(position: $cameraPosition, selection: $selectedResult) {
                        UserAnnotation()
                        
                        Annotation("Dixie Tech", coordinate: .schoolLocation) {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                Circle()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(authenticationViewModel.pink[0])
                                Image(systemName: "graduationcap.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        if let location = locationManager.placemark?.location?.coordinate {
                            Annotation("COORDINATE", coordinate: location) {
                                KFImage(URL(string: post.imageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 95, height: 95)
                                    .clipShape(.circle)
                                
                            }
                        }
                        
                        if let location = locationManager.location {
                            Annotation("Location", coordinate: location.coordinate) {
                                //                                ZStack {
                                postLocation
                                    .offset(x: 50, y: -25)
                                //                                    ForEach(feedViewModel.posts) { post in
                                //                                        KFImage(URL(string: post.imageUrl))
                                //                                            .resizable()
                                //                                            .scaledToFill()
                                //                                            .frame(width: 85, height: 85)
                                //                                            .clipShape(.circle)
                                //                                            .background(
                                //                                                Circle()
                                //                                                    .frame(width: 90, height: 90)
                                //                                                    .foregroundColor(authenticationViewModel.green[0]))
                                //                                    }
                                //                                }
                                
                            }
                        }
                        
                        
                        if let selectedPost = locationManager.postItem {
                            Annotation("Post Item", coordinate: selectedPost) {
                                ZStack {
                                    ForEach(feedViewModel.posts) { post in
                                        Circle()
                                            .frame(width: 80, height: 80)
                                            .foregroundColor(authenticationViewModel.pink[0])
                                        KFImage(URL(string: post.imageUrl))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 75, height: 75)
                                            .clipShape(.circle)
                                        
                                        
                                    }
                                }
                            }
                        }
                        
                        if let items = locationManager.item {
                            Annotation("Items", coordinate: items) {
                                ZStack {
                                    ForEach(feedViewModel.posts) { post in
                                        KFImage(URL(string: post.imageUrl))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 75, height: 75)
                                            .clipShape(.circle)
                                            .background(
                                                Circle()
                                                    .frame(width: 80, height: 80)
                                                    .foregroundColor(.white))
                                    }
                                }
                            }
                        }
                        
                        ForEach(results, id: \.self) { item in
                            if routeDisplaying {
                                if item == routeDestination {
                                    let placemark = item.placemark
                                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                                        .tint(authenticationViewModel.red[0])
                                }
                                
                            } else {
                                let placemark = item.placemark
                                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                                    .tint(authenticationViewModel.red[0])
                            }
                            if let route {
                                MapPolyline(route.polyline)
                                    .stroke(authenticationViewModel.blue[0].opacity(0.5), lineWidth: 5)
                            }
                        }
                    }
                    .mapStyle(.standard(elevation: .realistic))
                    .mapControls {
                        MapInformation()
                    }
                    .safeAreaInset(edge: .bottom) {
                        VStack {
                            MapItemView(cameraPosition: $cameraPosition, results: $results, visibleRegion: $visibleRegion, username: $username)
                                .padding(.leading, 325)
                                .padding()
                        }
                    }
                    .frame(width: 375, height: 625)
                    .cornerRadius(50)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 65, style: .circular)
                            .foregroundColor(authenticationViewModel.blue[0])
                            .frame(width: 405, height: 650)
                    )
                    .task {
                        locationManager.requestLocation()
                    }
                    
                    .onChange(of: getDirections, { oldValue, newValue in
                        if newValue {
                            fetchRoute()
                        }
                    })
                    .onChange(of: selectedResult, { oldValue, newValue in
                        showDetails = newValue != nil
                    })
                    
                    .sheet(isPresented: $showDetails, content: {
                        LocationInformation(selectedResult: $selectedResult, showDetails: $showDetails, getDirections: $getDirections, lookAroundScene: $lookAroundScene)
                            .presentationDetents([.height(350)])
                            .presentationBackgroundInteraction(.enabled(upThrough: .height(350)))
                            .presentationCornerRadius(50)
                    })
                    
                    VStack {
                        searchBar
                    }
                }
            }
            .background(LinearGradient(colors: [.clear, .clear, authenticationViewModel.violet[0].opacity(0.10)], startPoint: .bottom, endPoint: .bottomTrailing).ignoresSafeArea(.all))
        }
    }
}

extension LocationView {
    
    var postLocation: some View {
        ZStack {
            ForEach(feedViewModel.posts, id: \.self) { post in
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 85, height: 85)
                    .clipShape(.circle)
                    .background(
                        Circle()
                            .frame(width: 90, height: 90)
                            .foregroundColor(authenticationViewModel.green[0]))
                
            }
        }
    }
    
    var searchBar: some View {
        VStack {
            RoundedRectangle(cornerRadius: 25, style: .circular)
                .foregroundColor(authenticationViewModel.green[0])
                .frame(width: 350, height: 65)
                .overlay {
                    TextField("Search...", text: $searchText)
                        .foregroundColor(Color(.systemGray))
                        .fontWeight(.semibold)
                        .kerning(2.5)
                        .padding()
                        .cornerRadius(25)
                        .padding()
                        .background(.white)
                        .frame(width: 325, height: 45)
                        .clipShape(RoundedRectangle(cornerRadius: 17.5))
                        .onSubmit(of: .text) {
                            Task {
                                await searchPlaces()
                            }
                        }
                }
        }
    }
    
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
    
    func fetchRoute() {
        if let selectedResult {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: .schoolLocation))
            request.destination = selectedResult
            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                routeDestination = selectedResult
                withAnimation(.snappy) {
                    routeDisplaying = true
                    showDetails = false
                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
    }
}
