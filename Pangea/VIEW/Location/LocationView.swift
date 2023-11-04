//
//  LocationView.swift
//  Pangea
//
//  Created by Lillian Cain on 10/31/23.
//

import SwiftUI
import MapKit

struct LocationView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @State var cameraPosition: MapCameraPosition = .region(.userRegion)
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
    
    var body: some View {
        ScrollView {
            VStack {
                Map(position: $cameraPosition, selection: $selectedResult) {
                    
                    //        Marker("ME", coordinate: .userLocation)
                    
                    UserAnnotation()
                    
                    Annotation("Me!", coordinate: .schoolLocation) {
                        ZStack {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(.systemBlue).opacity(0.25))
                            
                            Circle()
                                .frame(width: 22.5, height: 22.5)
                                .foregroundColor(.white)
                            
                            Circle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                    
                    
                    ForEach(results, id: \.self) { item in
                        if routeDisplaying {
                            if item == routeDestination {
                                let placemark = item.placemark
                                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                            }
                        } else {
                            let placemark = item.placemark
                            Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                        }
                    }
                    if let route {
                        MapPolyline(route.polyline)
                            .stroke(authenticationViewModel.blue[0], lineWidth: 5)
                        
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .safeAreaInset(edge: .bottom) {
                    VStack {
                        MapItemView(cameraPosition: $cameraPosition, results: $results, visibleRegion: $visibleRegion, username: $username)
                            .padding(.leading, 325)
                        
                    }
                }
                .frame(width: 400, height: 635)
                .cornerRadius(50)
                .padding()
                
                .background(
                    RoundedRectangle(cornerRadius: 50, style: .circular)
                    .foregroundColor(authenticationViewModel.blue[0])
                    .frame(width: 412.5, height: 645)
                )
                
                
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
       
//                .mapControls {
//                    if isSelected {
//                        MapInformation()
//                    }
//                 
//                }
                
                VStack {
                    RoundedRectangle(cornerRadius: 25, style: .circular)
                        .foregroundColor(authenticationViewModel.green[0])
                        .frame(width: 350, height: 65)
                        .overlay {
                            TextField("Search...", text: $searchText)
                                .scrollDismissesKeyboard(.automatic)
                                .fontWeight(.semibold)
                                .kerning(2.5)
                                .padding()
                                .cornerRadius(25)
                                .padding()
                                .background(.white)
                                .foregroundColor(Color(.systemGray))
                                .frame(width: 325, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 17.5))
                               
                                .onSubmit(of: .text) {
                                    Task {
                                        await searchPlaces()
                                    }
                                }
                                
                        }
                }
//                .toolbarBackground(.ultraThinMaterial.opacity(0.05), for: .tabBar)
       
            }
        }
//        .background(LinearGradient(colors: [.clear, .clear, authenticationViewModel.violet[0].opacity(0.25)], startPoint: .topLeading, endPoint: .bottom))
    }
}

extension LocationView {
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
