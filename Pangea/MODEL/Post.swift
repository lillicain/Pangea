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
    
    var location: GeoPoint?
    var user: User?
}
