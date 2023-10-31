//
//  Post.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import Foundation
import Firebase
import CoreLocation

struct Post: Identifiable, Hashable, Codable {
    let id: String
    let userUid: String
    let caption: String
    let likes: Int
    let imageUrl: String
    let timestamp: Timestamp
    
    let location: String
    
    var user: User?
}

extension Post {
    static var MOCK_POST: [Post] = [
        Post(id: NSUUID().uuidString, userUid: User.MOCK_USER[0].id, caption: "First", likes: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "Dixie Tech"),
        Post(id: NSUUID().uuidString, userUid:  User.MOCK_USER[1].id, caption: "Second", likes: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "Dixie Tech"),
        Post(id: NSUUID().uuidString, userUid: User.MOCK_USER[2].id, caption: "Third", likes: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "Dixie Tech")
    ]
}
