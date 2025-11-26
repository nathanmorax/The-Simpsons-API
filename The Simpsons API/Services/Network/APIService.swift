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

          return try await decode(data)

        } catch let simpsonError as SimpsonError {
            throw simpsonError

        } catch {
            print("URLSession ERROR COMPLETO:")
            dump(error)
            throw SimpsonError.network(description: error.localizedDescription)
        }
    }

}

