import PencilKit
import UIKit

@MainActor
enum DayCoverArtworkFactory {
    static func makeArtwork(from drawing: PKDrawing, canvasSize: CGSize) -> DayCoverArtwork? {
        guard !drawing.strokes.isEmpty, canvasSize.width > 0, canvasSize.height > 0 else { return nil }
        // Include strokes outside the current viewport after a device size change.
        let bounds = CGRect(origin: .zero, size: canvasSize).union(drawing.bounds)
        let format = UIGraphicsImageRendererFormat()
        format.scale = min(2, 1024 / max(bounds.width, bounds.height))
        format.opaque = true
        let image = UIGraphicsImageRenderer(size: bounds.size, format: format).image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: bounds.size))
            drawing.image(from: bounds, scale: format.scale).draw(at: .zero)
        }
        guard let png = image.pngData() else { return nil }
        return DayCoverArtwork(editableDrawingData: drawing.dataRepresentation(), thumbnailPNGData: png)
    }
}
