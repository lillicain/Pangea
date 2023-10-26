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

class AuthenticationViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var backgroundColor: Color? 
    
    static let shared = AuthenticationViewModel()
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            loadUserData
        }
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
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAccount() async throws {
        try await Auth.auth().currentUser?.delete()
    }
}

protocol AuthenticationProtocol {
    var isValid: Bool { get }
}
