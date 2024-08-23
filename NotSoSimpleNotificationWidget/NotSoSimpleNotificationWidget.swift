import WidgetKit
import SwiftUI
import ActivityKit

struct NotSoSimpleNotificationWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityModelAttributes.self) { context in
            LiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    GIFImageView(imageName: "\(context.state.pokemonNumber)")
                        .frame(width: 25, height: 25)
                }
            } compactLeading: {
                // Minimal representation with only the Pokémon GIF
                GIFImageView(imageName: "\(context.state.pokemonNumber)")
                    .frame(width: 25, height: 25)
            } compactTrailing: {
                EmptyView() // No need for extra views
            } minimal: {
                GIFImageView(imageName: "\(context.state.pokemonNumber)")
                    .frame(width: 20, height: 20)
            }
        }
    }
}

struct LiveActivityView: View {
    let context: ActivityViewContext<LiveActivityModelAttributes>
    
    var body: some View {
        // Just an empty view as the focus is only on Pokémon GIFs in Dynamic Island
        EmptyView()
    }
}

@main
struct NotSoSimpleNotificationWidgetBundle: WidgetBundle {
    var body: some Widget {
        NotSoSimpleNotificationWidget()
    }
}
