//
//  StoreUsersRepository.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 03/04/25.
//

protocol StoreUsersRepository {
    func saveUsers(_ users: [UserData])
    func updateUserStatus(email: String, status: Int, completion: @escaping (Bool) -> Void)
    func getUsersWithStatus(status: [Int]) -> [MatchStatus]
    func getAllUsers() -> [People]
}
