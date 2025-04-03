//
//  StoreUsersUseCase.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 03/04/25.
//

class StoreUsersUseCase {
    
    private let storeRepository: StoreUsersRepository
    
    init(storeRepository: StoreUsersRepository) {
        self.storeRepository = storeRepository
    }
    
    func saveData(users: [UserData]) {
        storeRepository.saveUsers(users)
    }
    
    func updateUserStatus(email: String, status: Int, completion: @escaping (Bool) -> Void) {
        storeRepository.updateUserStatus(email: email, status: status, completion: completion)
    }
    
    func getUsersWithStatus(status: [Int]) -> [MatchStatus] {
        storeRepository.getUsersWithStatus(status: status)
    }
    
    func getAllUsers() -> [People] {
        storeRepository.getAllUsers()
    }
}
