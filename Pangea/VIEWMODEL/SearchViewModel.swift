//
//  SearchViewModel.swift
//  Pangea
//
//  Created by Lillian Cain on 10/23/23.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var users = [User]()
    
    init() {
        Task {
            try await fetchAllUsers()
        }
    }
    
    @MainActor
    func fetchAllUsers() async throws {
        self.users = try await UserManager.fetchAllUsers()
    }
}
