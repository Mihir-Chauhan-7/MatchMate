//
//  StoreUsersRepository.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 03/04/25.
//

class StoreUsersRepositoryImpl: StoreUsersRepository {
    
    private var dataBaseService: DatabaseManager
    
    init(dataBaseManager: DatabaseManager) {
        self.dataBaseService = dataBaseManager
    }

    func saveUsers(_ users: [UserData]) {
        dataBaseService.saveUser(users)
    }
    
    func updateUserStatus(email: String, status: Int, completion: @escaping (Bool) -> Void) {
        dataBaseService.updateUserStatus(email: email, status: status, completion: completion)
    }
    
    func getUsersWithStatus(status: [Int]) -> [MatchStatus] {
        dataBaseService.getUserStatusData(status: status)
    }
    
    func getAllUsers() -> [People] {
        dataBaseService.getAllUsers()
    }
}
