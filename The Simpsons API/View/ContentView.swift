//
//  ContentView.swift
//  The Simpsons API
//
//  Created by Jesus Mora on 25/11/25.
//

import SwiftUI

struct CharacterListView: View {
    
    @State var viewModel: HomeCharacterViewModel
    
    
    var body: some View {
        if viewModel.errorMessage == nil {
            List(viewModel.model, id: \.id) { character in
                CharacterRow(model: character)
                
            }
            .task {
                await viewModel.fetchCharacters()
            }
            
        } else {
            Text(viewModel.errorMessage ?? "Foo")
        }
    }
}

#Preview {
    let vm = HomeCharacterViewModel(
        characterService: TheSimpsonServiceImpl(APIService: APIService())
    )
    
    CharacterListView(viewModel: vm)
}


struct CharacterRow: View {
    let model: SimpsonsCharacterModel

    var body: some View {
        HStack {
            if let url = model.imageURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                } placeholder: {
                    ProgressView()
                }
            }

            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.headline)
                Text(model.occupation ?? "Unknown job")
                    .font(.subheadline)
            }
        }
    }
}

