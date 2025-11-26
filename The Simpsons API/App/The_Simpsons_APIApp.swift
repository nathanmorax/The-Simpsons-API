//
//  The_Simpsons_APIApp.swift
//  The Simpsons API
//
//  Created by Jesus Mora on 25/11/25.
//

import SwiftUI

@main
struct The_Simpsons_APIApp: App {
    var body: some Scene {
        WindowGroup {
            let vm = HomeCharacterViewModel(
                characterService: TheSimpsonServiceImpl(APIService: APIService())
            )
            CharacterListView(viewModel: vm)
            
        }
    }
}
