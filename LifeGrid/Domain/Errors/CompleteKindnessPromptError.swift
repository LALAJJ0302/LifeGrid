import Foundation

/// Describes a problem that prevents a student from recording a kindness action.
enum CompleteKindnessPromptError: LocalizedError, Equatable {
    case promptAlreadyCompleted
    case weeklyCompletionLimitReached

    var errorDescription: String? {
        switch self {
        case .promptAlreadyCompleted:
            return "This kindness prompt has already been completed."
        case .weeklyCompletionLimitReached:
            return "You have already recorded a kindness prompt this week."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .promptAlreadyCompleted:
            return "Keep this moment in your Memory Jar and choose a new prompt next week."
        case .weeklyCompletionLimitReached:
            return "Come back next week for a new prompt. One meaningful action is enough."
        }
    }
}
