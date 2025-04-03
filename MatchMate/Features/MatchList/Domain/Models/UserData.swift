//
//  User.swift
//  MatchMate
//
//  Created by Mihir Chauhan on 03/04/25.
//

struct UserData: Codable {
    let id: ID?
    let name: Name?
    let email: String?
    let picture: Image?
    let location: Location?
    
    struct ID: Codable {
        let value: String?
    }
    
    struct Name: Codable {
        let first: String?
        let last: String?
    }
    
    struct Location: Codable {
        let street: Street?
        let city: String?
        let state: String?
        let country: String?
    }
    
    struct Street: Codable {
        let name: String?
    }
    
    struct Image: Codable {
        let large: String?
        let medium: String?
        let thumbnail: String?
    }
}

