//
//  AnimationView.swift
//  NotSoSimpleNotification
//
//  Created by Parth Manaktala on 8/23/24.
//


import SwiftUI
import ActivityKit

struct AnimationView: View {
    var frameNames: [String]
    var activity: Activity<LiveActivityModelAttributes>? // Pass the activity

    var body: some View {
        VStack {
            if frameNames.isEmpty {
                Text("No animation to display")
            } else {
                if let activity = activity {
                    ImageSequenceView(frameNames: frameNames, currentFrame: activity.content.state.currentFrame)
                        .frame(width: 100, height: 100)
                        .padding()
                } else {
                    Text("No active Live Activity")
                }
            }
        }
    }
}
