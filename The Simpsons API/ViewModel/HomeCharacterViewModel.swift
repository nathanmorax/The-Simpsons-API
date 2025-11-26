//
//  HomeCharacterViewModel.swift
//  The Simpsons API
//
//  Created by Jesus Mora on 26/11/25.
//
import SwiftUI
import Observation

@Observable
class HomeCharacterViewModel {
    
    private let characterService: TheSimpsonServiceProtocol
    private(set) var model: [SimpsonsCharacterModel] = []
    private(set) var errorMessage: String?


    
    init(characterService: TheSimpsonServiceProtocol) {
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
