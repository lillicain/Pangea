//
//  PostItemViewModel.swift
//  Pangea
//
//  Created by Lillian Cain on 10/22/23.
//

import Foundation

class PostItemViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    private let user: User
    
    init(user: User) {
        self.user = user
        Task {
            try await fetchUserPosts()
        }
    }
    
    @MainActor
    func fetchUserPosts() async throws {
        self.posts = try await PostManager.fetchUserPosts(uid: user.id)
        for index in 0..<posts.count {
            posts[index].user = self.user
        }
    }
}
