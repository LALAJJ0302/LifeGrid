//
//  CreateDayCoverUseCase.swift
//  LifeGrid
//
//  Created by JJ on 7/9/2026.
//

import Foundation

/// Creates and saves a student's visual memory for one calendar day.
///
/// This use case protects the rules that a Day Cover must contain meaningful content and that each calendar day can have only one primary Day Cover.

struct CreateDayCoverUseCase {
    private let repository: any DayCoverRepository

    private let calendar: Calendar

    init(repository: any DayCoverRepository, calendar: Calendar = .current) {
        self.calendar = calendar
        self.repository = repository
    }

    @discardableResult
    func execute(dayCover: DayCover, today: Date = .now) throws -> DayCover {
        guard dayCover.hasMeaningfulContent else {
            throw CreateDayCoverError.emptyCover
        }

        guard calendar.startOfDay(for: dayCover.day) <= calendar.startOfDay(for: today) else {
            throw CreateDayCoverError.futureDateNotAllowed
        }

        guard repository.dayCover(for: dayCover.day) == nil else {
            throw CreateDayCoverError.dayAlreadyHasCover
        }

        repository.save(dayCover)

        return dayCover
    }
}
