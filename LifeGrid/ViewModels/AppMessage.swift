import Foundation

/// A human-readable message that a SwiftUI screen can present.
struct AppMessage: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let details: String
}

extension LocalizedError {
    var appMessage: AppMessage {
        let description = errorDescription ?? "Please try again."
        let recovery = recoverySuggestion ?? ""
        let combined = recovery.isEmpty ? description : "\(description)\n\n\(recovery)"
        return AppMessage(title: "We couldn't continue", details: combined)
    }
}
