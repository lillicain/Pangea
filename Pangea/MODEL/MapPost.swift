//
//  MapPost.swift
//  Pangea
//
//  Created by Lillian Cain on 10/31/23.
//

import Foundation
import Firebase

struct MapPost: Identifiable, Hashable, Codable {
    let id: String
    let userUid: String
    
    let imageUrl: String
    
    let post: Post
}
