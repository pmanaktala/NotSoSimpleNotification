import ActivityKit

struct LiveActivityModelAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var message: String
        var pokemonNumber: Int
        var frameNames: [String]
        var currentFrame: Int // Track the current frame
    }

    var name: String
}
