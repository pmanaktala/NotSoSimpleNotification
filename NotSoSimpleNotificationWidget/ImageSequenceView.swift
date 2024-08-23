//
//  ImageSequenceView.swift
//  NotSoSimpleNotification
//
//  Created by Parth Manaktala on 8/23/24.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct ImageSequenceView: View {
    var frameNames: [String]
    @State private var currentFrame: Int = 0
    private let animationDuration: Double // Total duration for one complete loop

    init(frameNames: [String], animationDuration: Double = 2.0) { // Default to 2 seconds
        self.frameNames = frameNames
        self.animationDuration = animationDuration
    }

    var body: some View {
        if !frameNames.isEmpty {
            let imageName = frameNames[currentFrame]
            let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.frames.shared")!
            let imagePath = sharedContainerURL.appendingPathComponent(imageName).path
            if let image = UIImage(contentsOfFile: imagePath) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .animation(.linear(duration: animationDuration / Double(frameNames.count)), value: currentFrame) // Apply animation
                    .onAppear {
                        startAnimation()
                    }
            } else {
                Text("Failed to load image: \(imageName)")
            }
        } else {
            Text("No frames to display")
        }
    }

    private func startAnimation() {
        guard !frameNames.isEmpty else { return }
        
        let frameDuration = animationDuration / Double(frameNames.count)
        
        func updateFrame() {
            DispatchQueue.main.asyncAfter(deadline: .now() + frameDuration) {
                currentFrame = (currentFrame + 1) % frameNames.count
                withAnimation(.linear(duration: frameDuration)) {
                    updateFrame()
                }
            }
        }
        
        updateFrame() // Start the animation loop
    }

}


