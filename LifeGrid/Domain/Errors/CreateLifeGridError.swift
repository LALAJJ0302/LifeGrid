//
//  CreateLifeGridError.swift
//  LifeGrid
//
//  Created by JJ on 10/9/2026.
//

import Foundation

/// Describes the business-rule errors that can occur when creating a LifeGrid.

enum CreateLifeGridError: Error, LocalizedError, Equatable {

    /// The entered age is below the minimum supported age.
    case ageBelowMinimum

    /// The entered age is above the maximum supported age.
    case ageAboveMaximum

    /// The number of years used by the visual frame is invalid.
    case invalidLifespanFrame

    var errorDescription: String? {
        switch self {
        case .ageBelowMinimum:
            return "Your age must be at least 1."

        case .ageAboveMaximum:
            return "LifeGrid currently supports ages up to 100."

        case .invalidLifespanFrame:
            return "The LifeGrid time frame could not be created."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .ageBelowMinimum:
            return "Enter an age between 1 and 100 to create your LifeGrid."

        case .ageAboveMaximum:
            return "Enter an age of 100 or below to continue."

        case .invalidLifespanFrame:
            return "Choose a time frame greater than zero and try again."
        }
    }
}
