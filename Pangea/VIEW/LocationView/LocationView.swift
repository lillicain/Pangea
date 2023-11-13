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
    @ObservedObject var postItemViewModel = PostItemViewModel(user: AuthenticationViewModel().currentUser ?? User.MOCK_USER[0])
    @ObservedObject var postViewModel = PostViewModel()
    
    @StateObject var locationManager = LocationManager()
    
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
                            schoolAnnotation
                        }
                        
                        Annotation("Home", coordinate: .homeLocation) {
                            homeAnnotation
                        }
                        
                        if let location = locationManager.placemark?.location?.coordinate {
                            Annotation("\(location)", coordinate: location) {
                                KFImage(URL(string: post.imageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 125, height: 125)
                                    .clipShape(.circle)
                            }
                        }
                        
                        if let location = locationManager.location {
                            Annotation("Post", coordinate: location.coordinate) {
                                postLocation
                                    .offset(x: 50, y: -25)
                            }
                        }
                        
                        
                        if let selectedPost = locationManager.coordinates {
                            Annotation("Post", coordinate: selectedPost) {
                                ZStack {
                                    ForEach(feedViewModel.posts) { post in
                                        Circle()
                                            .frame(width: 75, height: 75)
                                            .foregroundColor(.white)
                                        KFImage(URL(string: post.imageUrl))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 70)
                                            .clipShape(.circle)
                                        
                                    }
                                }
                            }
                        }
                        
                        if let items = locationManager.item {
                            Annotation("Post", coordinate: items) {
                                ZStack {
                                    ForEach(feedViewModel.posts.reversed()) { post in
                                        KFImage(URL(string: post.imageUrl))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 90, height: 90)
                                            .clipShape(.circle)
                                            .background(
                                                Circle()
                                                    .frame(width: 95, height: 95)
                                                    .foregroundColor(.white)
                                                
                                            )
                                    }
                                    
                                    .offset(x: 25, y: -25)
                                }
                            }
                        }
                        
                        ForEach(results, id: \.self) { item in
                            if routeDisplaying {
                                if item == routeDestination {
                                    let placemark = item.placemark
                                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                                        .tint(authenticationViewModel.blue[0])
                                }
                            } else {
                                let placemark = item.placemark
                                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                                    .tint(authenticationViewModel.blue[0])
                            }
                            if let route {
                                MapPolyline(route.polyline)
                                    .stroke(authenticationViewModel.blue[0].opacity(0.25), lineWidth: 5)
                            }
                        }
                    }
                    .mapStyle(.standard(elevation: .realistic))
                    .safeAreaPadding(.top, 25)
                    .safeAreaPadding(.trailing, 5)
                    .mapControls {
                        MapInformation()
                    }
                    .safeAreaInset(edge: .bottom) {
                        VStack {
                            MapItemView(cameraPosition: $cameraPosition, results: $results, visibleRegion: $visibleRegion, username: $username)
                                .padding(.leading, 315)
                                .padding(.bottom, 50)
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
                        
                        try? await feedViewModel.fetchPosts()
                        try? await postItemViewModel.fetchUserPosts()
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
                            .presentationDetents([.height(375)])
                            .presentationBackgroundInteraction(.enabled(upThrough: .height(375)))
                            .presentationCornerRadius(50)
                    })
                    
                    VStack {
                        searchBar
                    }
                }
            }
            .background(LinearGradient(colors: [.clear, .clear, authenticationViewModel.violet[0].opacity(0.05)], startPoint: .topTrailing, endPoint: .bottomTrailing).ignoresSafeArea(.all))
        }
    }
}

extension LocationView {
    
    var schoolAnnotation: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
            Circle()
                .frame(width: 45, height: 45)
                .foregroundColor(authenticationViewModel.pink[0])
            Image(systemName: "graduationcap")
                .foregroundColor(.white)
            
        }
    }
    
    var homeAnnotation: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
            Circle()
                .frame(width: 45, height: 45)
                .foregroundColor(authenticationViewModel.pink[0])
            Image(systemName: "house")
                .foregroundColor(.white)
        }
    }
    
    var postLocation: some View {
        ZStack {
            ForEach(feedViewModel.posts, id: \.self) { post in
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 95, height: 95)
                    .clipShape(.circle)
                    .background(
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                    )
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
                        .cornerRadius(25)
                        .padding()
                        .background(.white)
                        .frame(width: 325, height: 55)
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
