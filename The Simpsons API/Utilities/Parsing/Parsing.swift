//
//  Parsing.swift
//  The Simpsons API
//
//  Created by Jesus Mora on 26/11/25.
//
import Foundation

func decode<T: Decodable>(_ data: Data) async throws -> T {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    
    do {
        return try decoder.decode(T.self, from: data)
    } catch {
        throw SimpsonError.parsing(description: error.localizedDescription)
    }
}
