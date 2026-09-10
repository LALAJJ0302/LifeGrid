import Foundation

/// Editable strokes and a calendar preview; independent of UI frameworks.
struct DayCoverArtwork: Codable, Equatable {
    let editableDrawingData: Data
    let thumbnailPNGData: Data
}
