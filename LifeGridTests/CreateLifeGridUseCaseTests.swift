//
//  CreateLifeGridUseCaseTests.swift
//  LifeGrid
//
//  Created by JJ on 10/9/2026.
//

import Foundation
import Testing
@testable import LifeGrid

@MainActor
struct CreateLifeGridUseCaseTests {

    private let useCase = CreateLifeGridUseCase()

    @Test
    func createLifeGrid_succeeds_whenAgeIsValid() throws {
        let profile = try useCase.execute(
            currentAge: 21
        )

        #expect(profile.currentAge == 21)
        #expect(profile.lifespanFrameYears == 80)
        #expect(profile.totalWeeksInFrame == 4_160)
        #expect(profile.weeksLivedWithinFrame == 1_092)
        #expect(profile.remainingWeeksInFrame == 3_068)
    }

    @Test
    func createLifeGrid_hasNoRemainingWeeks_whenAgeReachesFrameLimit() throws {
        let profile = try useCase.execute(
            currentAge: 80
        )

        #expect(profile.totalWeeksInFrame == 4_160)
        #expect(profile.weeksLivedWithinFrame == 4_160)
        #expect(profile.remainingWeeksInFrame == 0)
    }

    @Test
    func createLifeGrid_fails_whenAgeIsBelowMinimum() {
        #expect(throws: CreateLifeGridError.ageBelowMinimum) {
            try useCase.execute(
                currentAge: 0
            )
        }
    }

    @Test
    func createLifeGrid_fails_whenAgeIsAboveMaximum() {
        #expect(throws: CreateLifeGridError.ageAboveMaximum) {
            try useCase.execute(
                currentAge: 101
            )
        }
    }

    @Test
    func createLifeGrid_fails_whenLifespanFrameIsInvalid() {
        #expect(throws: CreateLifeGridError.invalidLifespanFrame) {
            try useCase.execute(
                currentAge: 21,
                lifespanFrameYears: 0
            )
        }
    }
}
