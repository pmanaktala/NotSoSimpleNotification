import ActivityKit
import Foundation

struct LiveActivityModelAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Properties to update during the live activity
        var message: String
        var pokemonNumber: Int
    }
    
    // Properties set when the live activity starts
    var name: String
}
