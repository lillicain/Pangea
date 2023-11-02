//
//  Post.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import Foundation
import Firebase

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
        .init(id: NSUUID().uuidString, userUid: NSUserName(), caption: "Pangea Image", likes: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT"),
        .init(id: NSUUID().uuidString, userUid: NSUserName(), caption: "Pangea", likes: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT"),
        .init(id: NSUUID().uuidString, userUid: NSUserName(), caption: "Pangea", likes: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT")
    ]
}
