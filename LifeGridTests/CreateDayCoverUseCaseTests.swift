//
//  CreateDayCoverUseCaseTests.swift
//  LifeGrid
//
//  Created by JJ on 7/9/2026.
//

import Foundation
import Testing
@testable import LifeGrid

@MainActor
struct CreateDayCoverUseCaseTests {
    private let calendar = Calendar(identifier: .gregorian)

    @Test
    func createDayCover_succeeds_whenMoodIsSelected() throws {
        let repository = InMemoryDayCoverRepository(
            calendar: calendar
        )

        let useCase = CreateDayCoverUseCase(
            repository: repository
        )

        let day = makeDate(
            year: 2026,
            month: 9,
            day: 7,
            hour: 9
        )

        let dayCover = DayCover(
            day: day,
            mood: .happy
        )

        let savedDayCover = try useCase.execute(
            dayCover: dayCover
        )

        #expect(savedDayCover == dayCover)
        #expect(repository.dayCover(for: day) == dayCover)
        #expect(repository.allDayCovers().count == 1)
    }

    @Test
    func createDayCover_fails_whenCoverIsEmpty() {
        let repository = InMemoryDayCoverRepository(
            calendar: calendar
        )

        let useCase = CreateDayCoverUseCase(
            repository: repository
        )

        let emptyDayCover = DayCover(
            day: makeDate(
                year: 2026,
                month: 9,
                day: 7,
                hour: 9
            )
        )

        #expect(throws: CreateDayCoverError.emptyCover) {
            try useCase.execute(
                dayCover: emptyDayCover
            )
        }

        #expect(repository.allDayCovers().isEmpty)
    }

    @Test
    func createDayCover_fails_whenSameDayAlreadyHasCover() {
        let morning = makeDate(
            year: 2026,
            month: 9,
            day: 7,
            hour: 9
        )

        let evening = makeDate(
            year: 2026,
            month: 9,
            day: 7,
            hour: 20
        )

        let existingDayCover = DayCover(
            day: morning,
            mood: .calm
        )

        let repository = InMemoryDayCoverRepository(
            storedDayCovers: [existingDayCover],
            calendar: calendar
        )

        let useCase = CreateDayCoverUseCase(
            repository: repository
        )

        let secondDayCover = DayCover(
            day: evening,
            reflection: "I finished my assignment."
        )

        #expect(
            throws: CreateDayCoverError.dayAlreadyHasCover
        ) {
            try useCase.execute(
                dayCover: secondDayCover
            )
        }

        #expect(repository.allDayCovers().count == 1)
        #expect(repository.dayCover(for: morning) == existingDayCover)
    }

    private func makeDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int
    ) -> Date {
        calendar.date(
            from: DateComponents(
                year: year,
                month: month,
                day: day,
                hour: hour
            )
        )!
    }
}
