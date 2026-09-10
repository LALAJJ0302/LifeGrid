//
//  LifeGridProfile.swift
//  LifeGrid
//
//  Created by JJ on 10/9/2026.
//

import Foundation

/// Represents the age information used to create a student's LifeGrid.
///
/// LifeGrid uses an 80-year visual frame and represents each year
/// with 52 weekly cells. The result is a reflective estimate rather
/// than a prediction of the student's lifespan.
///
/// Business Rules:
/// - The student's age must be between 1 and 100.
/// - The visual frame contains 80 years.
/// - Each year is represented by 52 weekly cells.
struct LifeGridProfile: Codable, Equatable {
    let currentAge: Int
    let lifespanFrameYears: Int

    init(
        currentAge: Int,
        lifespanFrameYears: Int = 80
    ) {
        self.currentAge = currentAge
        self.lifespanFrameYears = lifespanFrameYears
    }

    var totalWeeksInFrame: Int {
        lifespanFrameYears * 52
    }

    var weeksLivedWithinFrame: Int {
        min(
            currentAge * 52,
            totalWeeksInFrame
        )
    }

    var remainingWeeksInFrame: Int {
        max(
            totalWeeksInFrame - weeksLivedWithinFrame,
            0
        )
    }
}
