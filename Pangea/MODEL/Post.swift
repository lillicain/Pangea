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
    let description: String
    let count: Int
    let imageUrl: String
    let timestamp: Timestamp
    let location: String
    
    let latitude: Double
    let longitude: Double
    var user: User?
}

extension Post {
    static var MOCK_POST: [Post] = [
        .init(id: NSUUID().uuidString, userUid: NSUserName(), description: "Pangea Image", count: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT", latitude: 0.0, longitude: 0.0),
        .init(id: NSUUID().uuidString, userUid: NSUserName(), description: "Pangea", count: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT", latitude: 0.0, longitude: 0.0),
        .init(id: NSUUID().uuidString, userUid: NSUserName(), description: "Pangea", count: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT", latitude: 0.0, longitude: 0.0),
    ]
    
//    static var MOCK_POST: [Post] = [
//        .init(id: NSUUID().uuidString, userUid: NSUserName(), description: "Pangea Image", count: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT"),
//        .init(id: NSUUID().uuidString, userUid: NSUserName(), description: "Pangea", count: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT"),
//        .init(id: NSUUID().uuidString, userUid: NSUserName(), description: "Pangea", count: 0, imageUrl: "", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT")
//    ]
    
}
