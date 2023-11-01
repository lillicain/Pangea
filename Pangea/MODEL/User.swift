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
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: username) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return currentUid == id
    }
}

extension User {
    static var MOCK_USER: [User] = [
        User(id: NSUUID().uuidString, username: "Pangea", email: "lillian@monark1.com", name: "Pangea"),
        User(id: NSUUID().uuidString, username: "PangeaPolice", email: "pangea@support.com", name: "Police", profileInformation: "Police Of This"),
        User(id: NSUUID().uuidString, username: "FraudAccount", email: "fraud@support.com", name: "Fraud", profileInformation: "🫵")
    ]
}


