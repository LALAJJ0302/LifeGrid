//
//  CreateLifeGridUseCase.swift
//  LifeGrid
//
//  Created by JJ on 10/9/2026.
//

import Foundation

/// Creates the profile used to display a student's weekly LifeGrid.
///
/// The use case validates the student's age and the number of years shown by the visual frame before creating the profile.
/// Business Rules:
/// - The student's age must be between 1 and 100.
/// - The lifespan frame must contain at least one year.
struct CreateLifeGridUseCase {

    private let minimumAge = 1
    private let maximumAge = 100

    /// Validates the supplied information and creates a LifeGrid profile.
    ///
    /// - Parameters:
    ///   - currentAge: The student's current age in completed years.
    ///   - lifespanFrameYears: The number of years displayed by the grid.
    /// - Returns: A validated profile containing the LifeGrid calculations.
    /// - Throws: A `CreateLifeGridError` when a business rule is violated.
    func execute(
        currentAge: Int,
        lifespanFrameYears: Int = 80
    ) throws -> LifeGridProfile {

        guard currentAge >= minimumAge else {
            throw CreateLifeGridError.ageBelowMinimum
        }

        guard currentAge <= maximumAge else {
            throw CreateLifeGridError.ageAboveMaximum
        }

        guard lifespanFrameYears > 0 else {
            throw CreateLifeGridError.invalidLifespanFrame
        }

        return LifeGridProfile(
            currentAge: currentAge,
            lifespanFrameYears: lifespanFrameYears
        )
    }
}
