////
////  MapView.swift
////  Pangea
////
////  Created by Lillian Cain on 10/19/23.
////
//
//import SwiftUI
//import MapKit
//import CoreLocationUI
//import CoreLocation
//import Firebase
//import FirebaseFirestore
//
//
//struct MapView: View {
//    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
//    
//    @StateObject var mapViewModel = LocationManager()
//    
//    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: .init(37.0975), longitude: .init(-11359915)), latitudinalMeters: .init(10000), longitudinalMeters: .init(10000))
//    
//    @State var results = [MKMapItem]()
//    @State var searchText = ""
//    @State var cameraPosition: MapCameraPosition = .region(.userRegion)
//    @State var selectedResult: MKMapItem?
//    @State var position: MapCameraPosition = .automatic
//    @State var visibleRegion: MKCoordinateRegion?
//    @State var lookAroundScene: MKLookAroundScene?
//    @State var isLookingAround: Bool = false
//    @State var showDetails = false
//    @State var getDirections = false
//    @State var routeDisplaying = false
//    @State var route: MKRoute?
//    @State var routeDestination: MKMapItem?
//    @State var searching = false
//    @State var username = ""
//    
//    let post: [Post] = []
//    
//    private var travelTime: String? {
//        guard let route else { return nil }
//        let formatter = DateComponentsFormatter()
//        formatter.unitsStyle = .abbreviated
//        formatter.allowedUnits = [.hour, .minute]
//        return formatter.string(from: route.expectedTravelTime)
//    }
//    
//    func searchPlaces() async {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchText
//        request.region = .userRegion
//        let results = try? await MKLocalSearch(request: request).start()
//        self.results = results?.mapItems ?? []
//    }
//    
//    func fetchRoute() {
//        if let selectedResult {
//            let request = MKDirections.Request()
//            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
//            request.destination = selectedResult
//            Task {
//                let result = try? await MKDirections(request: request).calculate()
//                route = result?.routes.first
//                routeDestination = selectedResult
//                withAnimation(.snappy) {
//                    routeDisplaying = true
//                    showDetails = false
//                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
//                        cameraPosition = .rect(rect)
//                    }
//                }
//            }
//        }
//    }
//    
//    var body: some View {
//        ScrollView {
//            Map(position: $position, selection: $selectedResult) {
//                
////                UserAnnotation()
//                
//                
//                
//                
//                //                ForEach(post) {
//                //                    Marker("", coordinate: CLLocationCoordinate2D(latitude: $0.location?.latitude ?? 39.0974, longitude: $0.location?.longitude ?? -113.5991))
//                //                }
//                //                ForEach(results, id: \.self) { item in
//                //                    Marker(item: item)
//                //                }
//                //
//                                if let route {
//                                    MapPolyline(route.polyline)
//                                        .stroke(Color(.systemGreen), lineWidth: 5)
//                                }
//            }
//            .onAppear {
//                position = .automatic
//            }
//                        .mapStyle(.standard(elevation: .realistic))
//                        .safeAreaInset(edge: .bottom) {
//                            HStack {
//                                Spacer()
//                                VStack {
//                                    MapItemView(position: $position, results: $results, visibleRegion: $visibleRegion, username: $username)
//                                        .padding(7.5)
//            
//                                }
//                                Spacer()
//                            }
//                            .background(.regularMaterial)
//            
//                        }
//            .frame(width: 375, height: 700)
//            .cornerRadius(25)
//            .background(authenticationViewModel.backgroundColor?.edgesIgnoringSafeArea(.all))
//        }
//    }
//}
//
//
////     @State var showSheet = false
////     @State var selectedImage: UIImage?
////     @State var date: Date?
////     @State var region = MKCoordinateRegion(
////         center: CLLocationCoordinate2D(
////            latitude: 37.094,
////            longitude: -113.5991),
////         latitudinalMeters: .init(10000),
////         longitudinalMeters: .init(10000))
////
////     var body: some View {
////         let regionWithOffset = Binding<MKCoordinateRegion>(
////         get: {
////             let offsetCenter = CLLocationCoordinate2D(latitude: region.center.latitude + region.span.latitudeDelta * 0.30, longitude: region.center.longitude)
////             return MKCoordinateRegion(
////                 center: offsetCenter,
////                 span: region.span)
////             },
////             set: {
////                 $0
////             }
////         )
////         return ZStack {
////             Map(coordinateRegion: regionWithOffset,
////                 interactionModes: MapInteractionModes.all,
////                 showsUserLocation: false,
////                 annotationItems: [region.center]) { item in
////
////                 MapPin(coordinate: item)
////
////
////
////             }
////             VStack {
////                 if let date = date {
////                     Text("\(date)")
////                         .padding()
////                         .background(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.9), Color.black.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
////                         .cornerRadius(10.0)
////                         .foregroundColor(.white)
////                         .padding()
////
////                 }
////                 if let image = selectedImage {
////                     Image(uiImage: image)
////                         .resizable()
////                         .aspectRatio(contentMode: .fit)
////                         .clipShape(Circle())
////                         .overlay(Circle().stroke(Color.white, lineWidth: 5))
////                         .shadow(radius: 10)
////                         .padding()
////                 }
////                 Spacer()
////                 Button(action: {
////                     showSheet.toggle()
////                 }) {
////                     Image(systemName: "photo")
////
////                 }
////                 .frame(width: 50, height: 50)
////                 .background(Color.white)
////                 .clipShape(Circle())
////                 .shadow(radius: 10)
////                 .padding()
////             }
////
////
////         }.sheet(isPresented: $showSheet) {
////             CustomPhotoPickerView(selectedImage: $selectedImage, date: $date, location: $region.center)
////         }
////     }
//// }
//
//
////    @StateObject var mapViewModel = MapViewModel()
////   @State var posts = [Post]()
//
////    var body: some View {
////        ScrollView {
////            Map(coordinateRegion: $mapViewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))
////
////
////            .frame(width: 350, height: 500)
////            .onAppear {
////                mapViewModel.requestLocation()
////            }
////        }
////    }
////}
//
//#Preview {
//    MapView()
//}
//
//struct MapItemView: View {
//    @Binding var position: MapCameraPosition
//    @Binding var results: [MKMapItem]
//    @Binding var visibleRegion: MKCoordinateRegion?
//    @Binding var username: String
//    
//    func searchPlaces(for query: String) {
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = query
//        request.resultTypes = .pointOfInterest
//        request.region = visibleRegion ?? MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.0975, longitude: -113.599), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//        Task {
//            let search = MKLocalSearch(request: request)
//            let response = try? await search.start()
//            results = response?.mapItems ?? []
//        }
//    }
//    
//    var body: some View {
//        HStack {
//            Button {
//                searchPlaces(for: "Parks")
//            } label: {
//                Image(systemName: "magnifyingglass")
//            }
//            
//            Button {
//                searchPlaces(for: "Places")
//            } label: {
//                Image(systemName: "mappin.and.ellipse")
//                
//            }
//            
//            Button {
//                position = .userLocation(fallback: .automatic)
//            } label: {
//                Image(systemName: "person.fill")
//            }
//            
//            Button {
//                position = .camera(MapCamera(centerCoordinate: .userLocation, distance: 900, heading: 300, pitch: 63))
//            } label: {
//                Image(systemName: "rotate.3d")
//            }
//            
//        }
//        .labelStyle(.iconOnly)
//        .buttonStyle(.borderedProminent)
//    }
//}
//
//struct MapControlView: View {
//    @Namespace var mapScope
//    
//    var body: some View {
//        ZStack {
//            MapUserLocationButton(scope: mapScope)
//            MapPitchToggle(scope: mapScope)
//            MapCompass(scope: mapScope)
//                .mapControlVisibility(.visible)
//        }
//        .padding()
//        .buttonBorderShape(.circle)
//        .mapScope(mapScope)
//    }
//}
//
//struct LocationInformationView: View {
//    @Binding var selectedResult: MKMapItem?
//    @Binding var isShowing: Bool
//    @Binding var getDirections: Bool
//    
//    @State var lookAroundScene: MKLookAroundScene?
//    
//    func fetchLookAroundPreview() {
//        if let selectedResult {
//            lookAroundScene = nil
//            Task {
//                let request = MKLookAroundSceneRequest(mapItem: selectedResult)
//                lookAroundScene = try? await request.scene
//            }
//        }
//    }
//    var body: some View {
//        VStack {
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(selectedResult?.placemark.name ?? "")
//                    
//                    Text(selectedResult?.placemark.title ?? "")
//                    
//                }
//                
//                Spacer()
//                
//                Button {
//                    isShowing.toggle()
//                    selectedResult = nil
//                } label: {
//                    Image(systemName: "xmark")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                        .foregroundStyle(.gray, Color(.systemGray5))
//                }
//            }
//            .padding(.horizontal)
//            .padding(.top)
//            
//            if let scene = lookAroundScene {
//                LookAroundPreview(initialScene: scene)
//                    .frame(height: 200)
//                    .cornerRadius(10)
//                    .padding()
//            } else {
//                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
//            }
//            
//            HStack(spacing: 25) {
//                Button {
//                    if let selectedResult {
//                        selectedResult.openInMaps()
//                    }
//                } label: {
//                    Text("Open Maps")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(width: 150, height: 50)
//                        .background(.green)
//                        .cornerRadius(10)
//                }
//                
//                Button {
//                    getDirections = true
//                    isShowing = false
//                    
//                } label: {
//                    Text("Get Directions")
//                        .frame(width: 150, height: 50)
//                        .cornerRadius(5)
//                }
//            }
//            .padding(.horizontal)
//        }
//        .onAppear {
//            fetchLookAroundPreview()
//        }
//        .onChange(of: selectedResult) { oldValue, newValue in
//            fetchLookAroundPreview()
//        }
//    }
//}
//
