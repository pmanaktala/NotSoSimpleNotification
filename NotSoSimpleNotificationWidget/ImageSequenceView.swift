import SwiftUI

struct ImageSequenceView: View {
    var frameNames: [String]
    var currentFrame: Int

    var body: some View {
        if !frameNames.isEmpty {
            let imageName = frameNames[currentFrame]
            let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.frames.shared")!
            let imagePath = sharedContainerURL.appendingPathComponent(imageName).path
            if let image = UIImage(contentsOfFile: imagePath) {
                
                let _ = print(imagePath)
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Failed to load image: \(imageName)")
            }
        } else {
            Text("No frames to display")
        }
    }
}
