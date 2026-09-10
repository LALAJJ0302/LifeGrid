//
//  Untitled.swift
//  LifeGrid
//
//  Created by JJ on 7/9/2026.
//

import Foundation

/// Describes a problem that prevents a student from saving a Day Cover.
///
/// Each error explains what happened in familiar language and gives the student a clear action they can take to recover.

enum CreateDayCoverError: LocalizedError, Equatable {
    case emptyCover
    case dayAlreadyHasCover
    case futureDateNotAllowed

    var errorDescription: String? {
        switch self {
        case .emptyCover:
            return "Your Day Cover is still empty."
        case .futureDateNotAllowed:
            return "A memory cannot be added to a future day."

        case .dayAlreadyHasCover:
            return "You already saved a Day Cover for this date."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .emptyCover:
            return "Add a drawing, choose a mood, or write a short reflection before saving."
        case .futureDateNotAllowed:
            return "Choose today or an earlier date to record a memory."

        case .dayAlreadyHasCover:
            return "Return to your Life Grid and open the existing cover for this day."
        }
    }
}
