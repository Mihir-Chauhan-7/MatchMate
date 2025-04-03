//
//  MatchListUseCase.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 03/04/25.
//
import Foundation
import Combine

class UsersUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(page: Int, results: Int) -> AnyPublisher<NetworkData, Error> {
        userRepository.fetchUsers(page: page, results: results)
    }
}
