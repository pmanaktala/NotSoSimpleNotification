import SwiftUI
import WidgetKit
import ActivityKit

struct NotSoSimpleNotificationWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityModelAttributes.self) { context in
            LiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    ImageSequenceView(frameNames: context.state.frameNames, currentFrame: context.state.currentFrame)
                        .frame(width: 50, height: 50)
                }
            } compactLeading: {
                ImageSequenceView(frameNames: context.state.frameNames, currentFrame: context.state.currentFrame)
                    .frame(width: 25, height: 25)
            } compactTrailing: {
                EmptyView()
            } minimal: {
                ImageSequenceView(frameNames: context.state.frameNames, currentFrame: context.state.currentFrame)
                    .frame(width: 20, height: 20)
            }
        }
    }
}

struct LiveActivityView: View {
    let context: ActivityViewContext<LiveActivityModelAttributes>

    var body: some View {
        ImageSequenceView(frameNames: context.state.frameNames, currentFrame: context.state.currentFrame)
            .frame(width: 75, height: 75)
    }
}

@main
struct NotSoSimpleNotificationWidgetBundle: WidgetBundle {
    var body: some Widget {
        NotSoSimpleNotificationWidget()
    }
}

