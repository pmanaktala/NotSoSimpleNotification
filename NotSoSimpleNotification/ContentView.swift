import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var selectedPokemon: Int = 1
    @State private var activity: Activity<LiveActivityModelAttributes>? = nil

    var body: some View {
        NavigationView {
            VStack {
                TabView {
                    MessageView(userInput: $userInput)
                        .tabItem {
                            Label("Message", systemImage: "text.bubble")
                        }

                    PokemonView(selectedPokemon: $selectedPokemon)
                        .tabItem {
                            Label("Pokémon", systemImage: "sparkles")
                        }
                }
                .navigationBarItems(trailing:
                    Button("Start") {
                        startLiveActivity(with: userInput, pokemonNumber: selectedPokemon)
                    }
                    .disabled(userInput.isEmpty)
                )
            }
        }
    }

    func startLiveActivity(with message: String, pokemonNumber: Int) {
        let attributes = LiveActivityModelAttributes(name: "NotSoSimpleNotificationApp")
        let contentState = LiveActivityModelAttributes.ContentState(message: message, pokemonNumber: pokemonNumber)

        do {
            activity = try Activity<LiveActivityModelAttributes>.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
        } catch {
            print("Error starting activity: \(error.localizedDescription)")
        }
    }
}
