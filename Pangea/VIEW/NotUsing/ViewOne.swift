////
////  ViewOne.swift
////  Pangea
////
////  Created by Lillian Cain on 10/19/23.
////
//
//import SwiftUI
//
////struct UserStatusView: View {
////    let value: Int
////    let title: String
////
////    var body: some View {
////        VStack {
////            Text("\(value)")
////            Text(title)
////        }
////        .frame(width: 75)
////    }
////}
//
//struct ViewOne: View {
//    var body: some View {
//        VStack(spacing: 25) {
//            Text("Sample Text").font(FontOne.large)
//            
//            Text("Sample Text").font(FontTwo.large)
//            
//            Text("Sample Text").font(FontThree.large)
//        
//            Text("Sample Text").font(FontFour.large)
//            Text("Sample Text").font(FontFive.large)
//            Text("Sample Text").font(FontSix.large)
//            Text("Sample Text").font(FontSeven.large)
//            Text("Sample Text").font(FontEight.large)
//        }
//    }
//}
//
//#Preview {
//    ViewOne()
//}
//
//
////struct ProfileView: View {
////    let user: User
////
////    var body: some View {
////        ScrollView {
////           Screen(user: user)
////            PostItemView(user: user)
////        }
////        .navigationTitle(user.username)
////        .navigationBarTitleDisplayMode(.inline)
////        .toolbar {
////            ToolbarItem(placement: .navigationBarTrailing) {
////                NavigationLink {
////
////                } label: {
////                    Text("Nothing yet")
////                }
////            }
////        }
////    }
////}
//
////struct CurrentUserProfileView: View {
////    let user: User
////
////    var body: some View {
////        ScrollView {
////            ProfileInformationView(user: user)
////            PostItemView(user: user)
////        }
////        .navigationBarTitleDisplayMode(.inline)
////        .toolbar {
////            ToolbarItem(placement: .navigationBarTrailing) {
////                Button {
////                    AuthenticationViewModel.shared.signOut()
////                } label: {
////                    Image(systemName: "house")
////                }
////            }
////        }
////    }
////}
////
////struct ProfileInformationView: View {
////    @State var showEditProfile = false
////
////    let user: User
////
////    var body: some View {
////        VStack {
////            HStack {
////                ProfileImageManager(user: user, size: .large)
////                    .padding(.top)
////
//////                Spacer()
//////
//////                HStack(spacing: 5) {
////////                    UserStatusView(value: 3, title: "Posts")
////////                    UserStatusView(value: 3, title: "Friends")
//////                }
//////                .padding(5)
////            }
//////            .padding(.horizontal)
//////            .padding(2.5)
////
////            VStack {
////                Text(user.username)
////                    .fontWeight(.bold)
////
////                if let name = user.name {
////                    Text(name)
////                        .fontWeight(.bold)
////                        .font(.footnote)
////                }
////                if let profileInformation = user.profileInformation {
////                    Text(profileInformation)
////                        .font(.footnote)
////                }
////            }
////            .frame(maxWidth: .infinity, alignment: .leading)
////            .padding(.horizontal)
////            .padding(2.5)
////
////            Button {
////                if user.isCurrentUser {
////                    showEditProfile.toggle()
////                }
////
////            } label: {
////                Text(user.isCurrentUser ? "Edit Profile" : "Add Friend")
////                    .frame(width: 100, height: 50)
////                    .background(user.isCurrentUser ? .white : Color(.systemGreen))
////                    .foregroundColor(.black)
////                    .fontWeight(.semibold)
////                    .cornerRadius(5)
////                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(user.isCurrentUser ? Color(.systemGray) : .clear))
////            }
////            .frame(alignment: .trailing)
////            Divider()
////        }
////        .fullScreenCover(isPresented: $showEditProfile) {
////            EditUserView(user: user)
////
////        }
////    }
////}
//
//
//
//
//
////struct CustomPhotoPickerView: UIViewControllerRepresentable {
////
////    @Binding var selectedImage: UIImage?
////    @Binding var date: Date?
////    @Binding var location: CLLocationCoordinate2D
////
////    @Environment(\.presentationMode) var presentationMode
////
////    func makeUIViewController(context: Context) -> PHPickerViewController {
////        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
////        config.filter = .images
////        config.selectionLimit = 1
////        let controller = PHPickerViewController(configuration: config)
////        controller.delegate = context.coordinator
////        return controller
////    }
////
////    func makeCoordinator() -> CustomPhotoPickerView.Coordinator {
////        return Coordinator(self)
////    }
////
////
////    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
////    }
////
////    class Coordinator: PHPickerViewControllerDelegate {
////        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
////            parent.presentationMode.wrappedValue.dismiss()
////            guard !results.isEmpty else {
////                return
////            }
////
////            let imageResult = results[0]
////
////            if let assetId = imageResult.assetIdentifier {
////                let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
////                DispatchQueue.main.async {
////                    self.parent.date = assetResults.firstObject?.creationDate
////                    if let coordinate  = assetResults.firstObject?.location?.coordinate {
////                        self.parent.location = coordinate
////                    }
////                }
////            }
////            if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
////                imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
////                    if let error = error {
////                        print(error.localizedDescription)
////                    } else {
////                        DispatchQueue.main.async {
////                            self.parent.selectedImage = selectedImage as? UIImage
////                        }
////                    }
////                }
////            }
////        }
////
////        private let parent: CustomPhotoPickerView
////        init(_ parent: CustomPhotoPickerView) {
////            self.parent = parent
////        }
////    }
////}
//
//
//
////struct mapTimelineView: View {
////
////    //    @StateObject private var locationViewModel = LocationManager.shared
////    //
////    @State private var showNewPostView = false
////    //
////    //    @ObservedObject var viewModel = TimelineViewModel()
////
////    @ObservedObject var authViewModel = AuthenticationViewModel()
////
////    @ObservedObject var obs = observer()
////
////    var body: some View {
////        ZStack (alignment: .bottomTrailing) {
////
////            //            Map(coordinateRegion: $locationViewModel.region, showsUserLocation: true)
////            //                .accentColor(Color("accentColor"))
////            //                .edgesIgnoringSafeArea(.all)
////
////            mapView(geopoints: self.obs.data["data"] as! [String : GeoPoint])
////
////            Button {
////                showNewPostView.toggle()
////            } label: {
////                Image(systemName: "plus")
////                    .resizable()
////                    .renderingMode(.template)
////                    .frame(width: 30, height: 30)
////                    .font(.system(size: 30, weight: .bold, design: .default))
////                    .padding()
////            }
////            .background(Color("accentColor"))
////            .foregroundColor(Color("backgroundColor"))
////            .clipShape(Circle())
////            .padding()
////            .shadow(radius: 20)
////            .fullScreenCover(isPresented: $showNewPostView) {
////                PostScreen()
////            }
////
////        }
////        .navigationBarTitleDisplayMode(.inline)
////        .navigationTitle("home")
////        .background(Color("backgroundColor"))
////    }
////}
////
////struct mapTimelineView_Previews: PreviewProvider {
////    static var previews: some View {
////        mapTimelineView()
////    }
////}
////
////struct mapView: UIViewRepresentable {
////
////    @ObservedObject var authViewModel = AuthenticationViewModel()
////
////    var geopoints : [String: GeoPoint]
////
////    func makeCoordinator() -> Coordinator {
////
////        return mapView.Coordinator(parent1: self)
////    }
////
////    let map = MKMapView()
////    let manager = CLLocationManager()
////
////    func makeUIView(context: Context) -> MKMapView {
////
////        manager.delegate = context.coordinator
////        manager.startUpdatingLocation()
////        map.showsUserLocation = true
////        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.856614, longitude: 2.3522219), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
////        map.region = region
////        return map
////    }
////
////    func updateUIView(_ uiView: MKMapView, context: Context) {
////
////        for i in geopoints {
////
////            let point = MKPointAnnotation()
////            point.coordinate = CLLocationCoordinate2D(latitude: i.value.latitude, longitude: i.value.longitude)
////            point.title = i.key
////            uiView.removeAnnotations(uiView.annotations)
////            uiView.addAnnotation(point)
////
////        }
////    }
////
////    class Coordinator: NSObject, CLLocationManagerDelegate {
////
////        @ObservedObject var authViewModel = AuthenticationViewModel()
////
////        var parent: mapView
////
////        init(parent1: mapView) {
////
////            parent = parent1
////
////        }
////
////        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////
////            guard let uid = self.authViewModel.userSession?.uid else { return }
////
////            let last = locations.last
////
////            Firestore.firestore().collection("locations").document("coordinate").setData(["updates" : [uid : GeoPoint(latitude: (last?.coordinate.latitude)!, longitude: (last?.coordinate.longitude)!)]],merge: true) { (err) in
////
////
////                if err != nil{
////
////                    print((err?.localizedDescription)!)
////                    return
////                }
////                print("success")
////            }
////        }
////    }
////}
////
////class observer : ObservableObject{
////
////    @Published var data = [String : Any]()
////
////    init() {
////
////        let db = Firestore.firestore()
////
////        db.collection("locations").document("coordinate").addSnapshotListener { (snap, err) in
////
////            if err != nil {
////
////                print((err?.localizedDescription)!)
////                return
////            }
////            let updates = snap?.get("updates") as! [String : GeoPoint]
////            self.data["data"] = updates
//////            let updates = snap?.get("data") as! [String : GeoPoint]
//////
//////            self.data["data"] = updates
////        }
////    }
////}
