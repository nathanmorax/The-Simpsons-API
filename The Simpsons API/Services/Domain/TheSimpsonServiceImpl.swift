//
//  TheSimpsonServiceImpl.swift
//  The Simpsons API
//
//  Created by Jesus Mora on 26/11/25.
//
import Foundation

class TheSimpsonServiceImpl: TheSimpsonServiceProtocol {
        
    private let APIService: APIServiceProtocol
    private let baseURL = "https://thesimpsonsapi.com/api"

    
    init(APIService: APIServiceProtocol) {
        self.APIService = APIService
    }
    
    func getAllCharacters() async throws -> [SimpsonsCharacterModel] {
        guard let url = URL(string: "\(baseURL)/characters") else {
            throw SimpsonError.invalidURL
        }


        do {
            let characters: SimpsonsPaginatedResponse = try await APIService.request(urlString: url)
            return characters.results
        } catch {
            print("Error en getAllCharacters:")
            dump(error)
            
            throw error
        }
    }

}
