//
//  TheSimpsonServiceProtocol.swift
//  The Simpsons API
//
//  Created by Jesus Mora on 26/11/25.
//

protocol TheSimpsonServiceProtocol {
    func getAllCharacters() async throws -> [SimpsonsCharacterModel]

}
