import UIKit
import ImageIO

extension UIImage {
    static func gif(name: String) -> UIImage? {
        guard let asset = NSDataAsset(name: name) else {
            print("Failed to load data asset with name: \(name)")
            return nil
        }

        guard let source = CGImageSourceCreateWithData(asset.data as CFData, nil) else {
            print("Failed to create CGImageSource from data asset")
            return nil
        }

        var images: [UIImage] = []
        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }

        let duration = Double(count) * 0.1 // Adjust this value as needed for your GIFs
        return UIImage.animatedImage(with: images, duration: duration)
    }
}

import SwiftUI
import UIKit

struct GIFImageView: UIViewRepresentable {
    var imageName: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        if let gifImage = UIImage.gif(name: imageName) {
            imageView.image = gifImage
        } else {
            imageView.image = UIImage(systemName: "photo") // Fallback image
        }

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        // Optionally update the view if your data changes
    }
}
