//
//  PeopleViewModel.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 02/04/25.
//

import Foundation
import Combine
import CoreData

enum MatchAcceptDeclineStatus: Int {
    typealias RawValue = Int
    
    case accepted = 1
    case declined = 2
    case unknown = 0
}

typealias MatchStatus = (email: String, status: Int)

class MatchListViewModel: ObservableObject {
    
    @Published var users: [People] = []
    @Published var userStatus: [MatchStatus] = []
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var isFinishAlertVisible = false
    
    private var usersUseCase: UsersUseCase
    private var storeUsersUseCase: StoreUsersUseCase
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 0
    private var isDataFinished: Bool = false
    
    var isEmptyData: Bool {
        return users.count == 0
    }
    
    var acceptedUsers: [MatchStatus] {
        return userStatus.filter({ $0.status == MatchAcceptDeclineStatus.accepted.rawValue })
    }
    
    var declinedUsers: [MatchStatus] {
        return userStatus.filter({ $0.status == MatchAcceptDeclineStatus.declined.rawValue })
    }
    
    init() {
        self.usersUseCase = UsersUseCase(userRepository: UserRepositoryImpl(apiService: APIManager()))
        self.storeUsersUseCase = StoreUsersUseCase(storeRepository: StoreUsersRepositoryImpl(dataBaseManager: DatabaseManager()))
    }
    
    func fetchUsers(page: Int, results: Int = 10) {
        self.isLoading = true
        self.isError = false
        usersUseCase.execute(page: page, results: results)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.isError = true
                    if error.localizedDescription == "The Internet connection appears to be offline." { // Need to add reachability to check network connection
                       self?.getUsersFromCoreData()
                    }
                    print("----- Failed to load user data \(error.localizedDescription) -----")
                case .finished:
                    print("----- User Data Loaded ------")
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] data in
                switch data {
                    case .failure(let error):
                        self?.isDataFinished = error.errorCode == 204
                        if (self?.users.count ?? 0) > 0 {
                            self?.isFinishAlertVisible = true
                        }
                        
                    case .success(let data):
                    self?.storeUsersUseCase.saveData(users: data.results)
                    let people: [People] = data.results.map({
                        let people = People(context: PersistenceController.shared.container.viewContext)
                        people.email = $0.email
                        people.firstName = $0.name?.first ?? ""
                        people.lastName = $0.name?.last ?? ""
                        people.imageLarge = $0.picture?.large ?? ""
                        people.imageMedium = $0.picture?.medium ?? ""
                        people.imageThumbnail = $0.picture?.thumbnail ?? ""
                        return people
                    })
                    
                    self?.users.append(contentsOf: people)
                    print("----- Received Users for Page \(data.results.count) \(page)")
                }
            })
            .store(in: &cancellables)
    }
    
    func updateProfile(email: String, status: Int) {
        self.storeUsersUseCase.updateUserStatus(email: email, status: status) { isUpdated in
            if isUpdated {
                self.userStatus.append(MatchStatus(email: email, status: status))
            }
        }
    }
    
    func loadMoreUsers(currentIndex: Int) {
        guard currentIndex == users.count - 1 else { return }
        self.getUsers()
    }
    
    func getUsers() {
        if !isDataFinished && !isLoading {
            currentPage += 1
            fetchUsers(page: self.currentPage)
        }
    }
    
    func getAcceptedDeclinedStatus() {
        userStatus = self.storeUsersUseCase.getUsersWithStatus(status: [1, 2])
    }

    func isAccepted(email: String) -> Bool {
        self.acceptedUsers.contains(where: { $0.email == email })
    }
    
    func isDeclined(email: String) -> Bool {
        self.declinedUsers.contains(where: { $0.email == email })
    }
    
    func getStatus(email: String) -> Int {
        return (self.isAccepted(email: email)
                ? MatchAcceptDeclineStatus.accepted : self.isDeclined(email: email)
                ? MatchAcceptDeclineStatus.declined : MatchAcceptDeclineStatus.unknown).rawValue
    }
    
    func getUsersFromCoreData() {
        self.isLoading = true
        self.users = self.storeUsersUseCase.getAllUsers() ?? []
        self.isError = false
        self.isLoading = false
        print("Users Loaded \((self.users ?? []).count)")
    }
}
