import SwiftUI
import BackgroundTasks
import ActivityKit

struct ContentView: View {
    @State private var userInput: String = "Enter Text"
    @State private var selectedPokemon: Int = 1
    @State private var activity: Activity<LiveActivityModelAttributes>? = nil
    @State private var frameNames: [String] = []

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

                    AnimationView(frameNames: frameNames, activity: activity)
                        .tabItem {
                            Label("Animation", systemImage: "photo.on.rectangle")
                        }
                }
                .navigationBarItems(leading:
                    Button("Stop") {
                        Task {
                            await stopLiveActivity()
                        }
                    }
                    .disabled(activity == nil),
                    trailing:
                    Button("Start") {
                        Task {
                            if let gifData = loadGIFData(for: selectedPokemon) {
                                frameNames = extractAndSaveFrames(from: gifData, for: selectedPokemon)
                                await startLiveActivity(with: userInput, pokemonNumber: selectedPokemon, gifData: gifData)
                                await animateLiveActivity()
                            }
                        }
                    }
                    .disabled(userInput.isEmpty || activity != nil)
                )
            }
        }
        .onAppear {
            registerBackgroundTasks()
        }
    }

    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.pmanaktala.refresh", using: nil) { task in
            handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        task.expirationHandler = {
            // Handle the task expiration
            task.setTaskCompleted(success: false)
        }

        // Perform the task's work
        Task {
            await animateLiveActivity() // Or any other relevant function
        }

        task.setTaskCompleted(success: true)
        scheduleAppRefresh() // Reschedule the task
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.pmanaktala.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes later
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }

    func startLiveActivity(with message: String, pokemonNumber: Int, gifData: Data) async {
        await stopLiveActivity()
        let frameNames = extractAndSaveFrames(from: gifData, for: pokemonNumber)

        let attributes = LiveActivityModelAttributes(name: "NotSoSimpleNotificationApp")
        let contentState = LiveActivityModelAttributes.ContentState(message: message, pokemonNumber: pokemonNumber, frameNames: frameNames, currentFrame: 0)
        let activityContent = ActivityContent(state: contentState, staleDate: nil)

        do {
            activity = try await Activity<LiveActivityModelAttributes>.request(
                attributes: attributes,
                content: activityContent,
                pushType: nil
            )
            scheduleAppRefresh() // Schedule background task
        } catch {
            print("Error starting activity: \(error.localizedDescription)")
        }
    }

    func animateLiveActivity() async {
        guard let activity = activity else { return }
        guard !frameNames.isEmpty else { return }

        let frameRate: Double = 60.0 // Adjusted frame rate
        let frameDuration: Double = 1.0 / frameRate

        for i in 0..<frameNames.count {
            let updatedContentState = LiveActivityModelAttributes.ContentState(
                message: activity.content.state.message,
                pokemonNumber: activity.content.state.pokemonNumber,
                frameNames: activity.content.state.frameNames,
                currentFrame: i
            )

            let updatedContent = ActivityContent(state: updatedContentState, staleDate: nil)

            do {
                await activity.update(updatedContent)
                try await Task.sleep(nanoseconds: UInt64(frameDuration * 1_000_000_000)) // Sleep between frames
            } catch {
                print("Error updating activity: \(error.localizedDescription)")
                break
            }
        }

        // Loop the animation
        Task {
            await animateLiveActivity()
        }
    }

    func stopLiveActivity() async {
        await activity?.end(dismissalPolicy: .immediate)
        activity = nil
        await clearTemporaryFrames()
    }

    func loadGIFData(for pokemonNumber: Int) -> Data? {
        guard let path = Bundle.main.path(forResource: "\(pokemonNumber)", ofType: "gif"),
              let gifData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("Failed to load GIF for Pokémon \(pokemonNumber)")
            return nil
        }
        return gifData
    }

    func extractAndSaveFrames(from gifData: Data, for pokemonNumber: Int) -> [String] {
        var frameNames: [String] = []
        let options: [CFString: Any] = [kCGImageSourceShouldCache: false]
        guard let imageSource = CGImageSourceCreateWithData(gifData as CFData, options as CFDictionary) else {
            print("Failed to create image source from GIF data")
            return frameNames
        }
        let frameCount = CGImageSourceGetCount(imageSource)

        for i in 0..<frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) {
                let frame = UIImage(cgImage: cgImage)
                let frameName = "\(pokemonNumber)_frame_\(i).png"
                if saveImage(frame, withName: frameName) {
                    frameNames.append(frameName)
                    print("Saved frame \(i) as \(frameName)")
                }
            } else {
                print("Failed to create image for frame \(i)")
            }
        }

        return frameNames
    }

    func saveImage(_ image: UIImage, withName name: String) -> Bool {
        if let data = image.pngData() {
            let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.frames.shared")!
            let fileURL = sharedContainerURL.appendingPathComponent(name)
            do {
                try data.write(to: fileURL)
                return true
            } catch {
                print("Error saving image \(name): \(error)")
                return false
            }
        }
        return false
    }

    func clearTemporaryFrames() async {
        let fileManager = FileManager.default
        guard let sharedContainerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.frames.shared") else {
            print("Error accessing shared container")
            return
        }

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: sharedContainerURL, includingPropertiesForKeys: nil)
            let regexPattern = #"^\d+_frame_\d+\.png$"#

            for fileURL in fileURLs {
                let fileName = fileURL.lastPathComponent

                // Check if the file name matches the pattern using regex
                if let _ = fileName.range(of: regexPattern, options: .regularExpression) {
                    do {
                        try fileManager.removeItem(at: fileURL)
                        print("Deleted file: \(fileURL)")
                    } catch {
                        print("Error deleting file \(fileURL): \(error)")
                    }
                }
            }
        } catch {
            print("Error clearing temporary frames: \(error)")
        }
    }
}
