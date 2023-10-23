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
    static var MOCK_USER = User(id: NSUUID().uuidString, username: "username", email: "user@user.com")
}


