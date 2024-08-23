import ActivityKit
import Foundation

struct LiveActivityModelAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var message: String
        var pokemonNumber: Int
        var frameNames: [String]

        init(message: String, pokemonNumber: Int, frameNames: [String], currentFrame: Int = 0) {
            self.message = message
            self.pokemonNumber = pokemonNumber
            self.frameNames = frameNames
        }
    }

    var name: String
}

