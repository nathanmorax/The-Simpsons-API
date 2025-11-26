//
//  APIService.swift
//  The Simpsons API
//
//  Created by Jesus Mora on 25/11/25.
//

import Foundation
import Observation

enum SimpsonError: Error {
    case parsing(description: String)
    case network(description: String)
    case invalidURL
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .parsing(let description):
            return "Error de parsing: \(description)"
        case .network(let description):
            return "Error de red: \(description)"
        case .invalidURL:
            return "URL inválida"
        case .unknown:
            return "Error desconocido"
        }
    }
}

protocol APIServiceProtocol {
    func request<T: Decodable>(urlString: URL) async throws -> T
}

class APIService: APIServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(urlSession: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = urlSession
        self.decoder = decoder
    }
    
    func request<T: Decodable>(urlString: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: urlString)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw SimpsonError.network(description: "Respuesta inválida")
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? "No readable body"
                throw SimpsonError.network(description:
                    "HTTP \(httpResponse.statusCode)\nBODY: \(body)"
                )
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                let raw = String(data: data, encoding: .utf8) ?? "No readable body"
                throw SimpsonError.parsing(
                    description: "\(error.localizedDescription)\nRAW BODY: \(raw)"
                )
            }

        } catch let simpsonError as SimpsonError {
            throw simpsonError

        } catch {
            print("URLSession ERROR COMPLETO:")
            dump(error)
            throw SimpsonError.network(description: error.localizedDescription)
        }
    }

    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw SimpsonError.parsing(description: error.localizedDescription)
        }
    }

}



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



extension SimpsonsCharacterModel {
    var imageURL: URL? {
        guard let portrait_path else { return nil }
        return URL(string: "https://cdn.thesimpsonsapi.com/500\(portrait_path)")
    }
}

struct Relative: Codable, Identifiable {
    let name: String
    let relation: String
    
    var id: String { name + relation }
}

protocol TheSimpsonService {
    func getAllCharacters() async throws -> [SimpsonsCharacterModel]

}

class TheSimpsonServiceImpl: TheSimpsonService {
        
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


@Observable
class HomeCharacterViewModel {
    
    private let characterService: TheSimpsonService
    private(set) var model: [SimpsonsCharacterModel] = []
    private(set) var errorMessage: String?


    
    init(characterService: TheSimpsonService) {
        self.characterService = characterService
    }

    
    @MainActor
    func fetchCharacters() async {
        
        do {
            let response = try await characterService.getAllCharacters()
            print("response:: ",response)
            
            self.model = response
        } catch  let error {
            self.errorMessage = error.localizedDescription
            print("Error: ", errorMessage)
        }
    }

}


