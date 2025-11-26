//
//  SimpsonsCharacterModel.swift
//  The Simpsons API
//
//  Created by Jesus Mora on 26/11/25.
//
import Foundation

struct SimpsonsCharacterModel: Codable, Identifiable {
    let id: Int
    let age: Int?
    let birthdate: String?
    let gender: String?
    let name: String
    let occupation: String?
    let portrait_path: String?
    let phrases: [String]?
    let status: String?
}

struct SimpsonsPaginatedResponse: Codable {
    let count: Int
    let next: String?
    let prev: String?
    let pages: Int
    let results: [SimpsonsCharacterModel]
}

struct Relative: Codable, Identifiable {
    let name: String
    let relation: String
    
    var id: String { name + relation }
}


extension SimpsonsCharacterModel {
    var imageURL: URL? {
        guard let portrait_path else { return nil }
        return URL(string: "https://cdn.thesimpsonsapi.com/500\(portrait_path)")
    }
}
