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
        Post(id: NSUUID().uuidString, userUid: User.MOCK_USER[0].id, caption: "Image", likes: 0, imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/pangea-3bcf8.appspot.com/o/profile_images%2F8C287046-51F0-4468-93B1-C17D270738EF?alt=media&token=e71b61ab-7323-45bc-9ce2-e03374c10eee", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT"),
        
        Post(id: NSUUID().uuidString, userUid:  User.MOCK_USER[1].id, caption: "Image", likes: 0, imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/pangea-3bcf8.appspot.com/o/profile_images%2F8C287046-51F0-4468-93B1-C17D270738EF?alt=media&token=e71b61ab-7323-45bc-9ce2-e03374c10eee", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT"),
        
        Post(id: NSUUID().uuidString, userUid: User.MOCK_USER[2].id, caption: "Image", likes: 0, imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/pangea-3bcf8.appspot.com/o/profile_images%2F8C287046-51F0-4468-93B1-C17D270738EF?alt=media&token=e71b61ab-7323-45bc-9ce2-e03374c10eee", timestamp: Timestamp(date: .now), location: "610 South Tech Ridge Drive, Saint George, UT")
    ]
}
