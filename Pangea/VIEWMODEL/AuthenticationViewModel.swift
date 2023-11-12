//
//  AuthenticationViewModel.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class AuthenticationViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var currentSignInStatus = SignInState.pangea
    
    @Published var backgroundColor: Color?
    @Published var blue = ["0030FF"].hexToColorArray()
    @Published var green = ["CCFF00"].hexToColorArray()
    @Published var violet = ["480CA8"].hexToColorArray()
    @Published var pink = ["FF3B5B"].hexToColorArray()
    @Published var orange = ["FF4500"].hexToColorArray()
    @Published var black = ["0C0F0A"].hexToColorArray()
    @Published var white = ["FDFFFC"].hexToColorArray()
    
    static let shared = AuthenticationViewModel()
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            do {
                try await loadUserData()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func changeSignUpState(to signInState: SignInState) {
        currentSignInStatus = signInState
    }
    
    @MainActor
    func createUser(email: String, username: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            await uploadUserData(uid: result.user.uid, username: username, email: email)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func loadUserData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = userSession?.uid else { return }
        _ = try await Firestore.firestore().collection("users").document(currentUid).getDocument()
        self.currentUser = try await UserManager.fetchUser(withUid: currentUid)
    }
    
    func uploadUserData(uid: String, username: String, email: String) async {
        let user = User(id: uid, username: username, email: email)
        self.currentUser = user
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try? await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
    }
    
    func deleteAccount() async throws {
        try await Auth.auth().currentUser?.delete()
    }
}
