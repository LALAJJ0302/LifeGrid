import Foundation

/// Describes why a message cannot yet become a Time Capsule.
enum CreateTimeCapsuleError: LocalizedError, Equatable {
    case emptyMessage
    case openingDateNotFuture

    var errorDescription: String? {
        switch self {
        case .emptyMessage:
            return "Your message to your future self is still empty."
        case .openingDateNotFuture:
            return "A Time Capsule needs an opening date in the future."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .emptyMessage:
            return "Write a short thought, hope, or reminder before sealing it."
        case .openingDateNotFuture:
            return "Choose a later date so this memory has time to become a capsule."
        }
    }
}
