import Foundation

enum BrowseDayCoversError: LocalizedError, Equatable {
    case dateRangeUnavailable
    var errorDescription: String? { "This memory period could not be opened." }
    var recoverySuggestion: String? { "Choose another date or time period and try again." }
}
