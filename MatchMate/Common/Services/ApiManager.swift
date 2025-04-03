//
//  ApiManager.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 03/04/25.
//

import Combine
import Foundation

enum NetworkData {
    case success(MatchListData)
    case failure(FailedResult)
}

struct FailedResult : Decodable {
    let errorCode : Int
    let failureReason : String
}

class APIManager {
    
    private let baseURL = "https://randomuser.me/api/"
    private let timeoutInterval: TimeInterval = 15
    private let numberOfRetries: Int = 2
    
    func fetchUsers(page: Int, results: Int) -> AnyPublisher<NetworkData, Error> {
        let url = URL(string: "\(baseURL)?page=\(page)&results=\(results)")!
        //let url = URL(string: "https://httpstat.us/504?sleep=60000")!
        
        print("----- \(url.absoluteString)")
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MatchListData.self, decoder: JSONDecoder())
            .retry(2)
            .timeout(.seconds(timeoutInterval), scheduler: DispatchQueue.main)
            .tryMap { networkData -> NetworkData in
                if (networkData.info?.page ?? -1) == page {
                    return NetworkData.success(networkData)
                }
                return NetworkData.failure(FailedResult(errorCode: 204, failureReason: "No Data"))
            }
            .delay(for: 1, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
