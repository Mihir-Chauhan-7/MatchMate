//
//  PeopleData.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 03/04/25.
//
import Foundation


import Foundation

struct MatchListData: Codable {
    let results: [UserData]
    let info: Info?
}

struct Info: Codable {
    let seed: String?
    let results, page: Int?
    let version: String?
}
