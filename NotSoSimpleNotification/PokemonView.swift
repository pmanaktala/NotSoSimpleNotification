import SwiftUI
import FLAnimatedImage

struct PokemonView: View {
    @Binding var selectedPokemon: Int
    let pokemonCount = 500  // Total number of Pokémon

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                ForEach(1...pokemonCount, id: \.self) { index in
                    VStack {
                        // Attempt to load gif from the app bundle using a local file path
                        if let path = Bundle.main.path(forResource: "\(index)", ofType: "gif"),
                           let gifData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                            FLAnimatedImageViewWrapper(gifData: gifData)
                                .frame(width: 80, height: 80)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(35)
                                .overlay(
                                    Circle().stroke(Color.gray, lineWidth: selectedPokemon == index ? 2 : 0)
                                )
                        } else {
                            // Fallback for missing assets
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .cornerRadius(40)
                                .overlay(
                                    Circle().stroke(Color.gray, lineWidth: selectedPokemon == index ? 2 : 0)
                                )
                        }

                        Text(PokeDex.pokemon[index, default: "Unknown Pokémon"])
                            .font(.caption)
                            .foregroundColor(.primary)
                            .padding(.top, 4)

                        // Checkmark for selected Pokémon
                        if selectedPokemon == index {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(selectedPokemon == index ? Color.blue.opacity(0.2) : Color(.systemGray6))
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .onTapGesture {
                        self.selectedPokemon = index  // Update selected Pokémon on tap
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Select a Pokémon")
    }
}

// A custom view to display Gif images using FLAnimatedImage
struct FLAnimatedImageViewWrapper: UIViewRepresentable {
    var gifData: Data

    func makeUIView(context: Context) -> FLAnimatedImageView {
        let imageView = FLAnimatedImageView()
        let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
        imageView.animatedImage = animatedImage
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    func updateUIView(_ uiView: FLAnimatedImageView, context: Context) {}
}
