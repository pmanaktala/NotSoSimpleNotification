//
//  PokemonView.swift
//  NotSoSimpleNotification
//
//  Created by Parth Manaktala on 8/22/24.
//


import SwiftUI

struct PokemonView: View {
    @Binding var selectedPokemon: Int
    let pokemonCount = 500  // Total number of Pokémon

    var body: some View {
        List(1...pokemonCount, id: \.self) { index in
            HStack {
                GIFImageView(imageName: "\(index)")
                    .frame(width: 50, height: 50) // Adjusted frame size
                    .cornerRadius(25) // Adjusted corner radius to match the new frame size
                
                Text(PokeDex.pokemon[index, default: "Unknown Pokémon"])
                
                Spacer()
                
                // Checkmark for selected Pokémon
                if selectedPokemon == index {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 4) // Ensuring vertical padding to enhance tap area
            .background(selectedPokemon == index ? Color.blue.opacity(0.2) : Color.clear) // Highlight background
            .cornerRadius(10) // Rounded corners for highlight
            .onTapGesture {
                self.selectedPokemon = index
            }
        }
    }
}

