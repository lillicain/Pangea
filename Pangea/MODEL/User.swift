//
//  User.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import Foundation
import Firebase
import FirebaseAuth

struct User: Identifiable, Hashable, Codable {
    let id: String
    let username: String
    let email: String
    var name: String?
    var profileImage: String?
    var profileInformation: String?
   
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return currentUid == id
    }
}

extension User {
    static var MOCK_USER: [User] = [
        .init(id: NSUUID().uuidString, username: "Pangea", email: "lillian@monark1.com", name: "Pangea"),
        .init(id: NSUUID().uuidString, username: "Support", email: "pangea@support.com", name: "Support", profileInformation: "Information"),
        .init(id: NSUUID().uuidString, username: "Fraud", email: "fraud@support.com", name: "Fraud", profileInformation: "Information")
    ]
}


