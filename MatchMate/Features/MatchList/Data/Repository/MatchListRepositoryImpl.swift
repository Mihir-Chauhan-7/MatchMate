//
//  MatchListRepository.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 03/04/25.
//
import Foundation
import Combine

class UserRepositoryImpl: UserRepository {
    
    private let apiService: APIManager
    
    init(apiService: APIManager) {
        self.apiService = apiService
    }

    func fetchUsers(page: Int, results: Int) -> AnyPublisher<NetworkData, Error> {
        apiService.fetchUsers(page: page, results: results)
            .eraseToAnyPublisher()
    }
}

