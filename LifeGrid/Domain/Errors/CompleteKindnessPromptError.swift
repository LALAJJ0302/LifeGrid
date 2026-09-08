//
//  CompleteKindnessPromptError.swift
//  LifeGrid
//
//  Created by JJ on 8/9/2026.
//

import Foundation

/// Describes a problem that prevents a student from completing a Kindness Prompt.
///
/// The messages acknowledge the student's progress and provide a clear next step without turning kindness into a source of pressure.

enum CompleteKindnessPromptError: LocalizedError, Equatable {
    case promptAlreadyCompleted
    case dailyCompletionLimitReached

    var errorDescription: String? {
        switch self {
        case .promptAlreadyCompleted:
            return "This kindness prompt has already been completed."

        case .dailyCompletionLimitReached:
            return "You have already completed a kindness prompt today."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .promptAlreadyCompleted:
            return "Choose a different prompt or revisit this moment in your Life Grid."

        case .dailyCompletionLimitReached:
            return "Come back tomorrow for a new prompt. One meaningful action is enough for today."
        }
    }
}
