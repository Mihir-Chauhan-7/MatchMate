//
//  MatchListRepository.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 03/04/25.
//
import Foundation
import Combine

protocol UserRepository {
    func fetchUsers(page: Int, results: Int) -> AnyPublisher<NetworkData, Error>
}


