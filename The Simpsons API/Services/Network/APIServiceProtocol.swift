//
//  APIServiceProtocol.swift
//  The Simpsons API
//
//  Created by Jesus Mora on 26/11/25.
//
import Foundation

protocol APIServiceProtocol {
    func request<T: Decodable>(urlString: URL) async throws -> T
}
