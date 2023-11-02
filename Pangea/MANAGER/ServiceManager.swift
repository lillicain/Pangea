//
//  ServiceManager.swift
//  Pangea
//
//  Created by Lillian Cain on 11/1/23.
//

import Foundation
import Firebase
import Combine

class ServiceManager: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    var service = AuthenticationViewModel.shared
    var cancellables = Set<AnyCancellable>()

    init() {
        setupSubscribers()
    }

    func setupSubscribers() {
        service.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellables)
    }
}
