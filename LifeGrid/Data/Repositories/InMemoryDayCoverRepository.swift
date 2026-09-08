//
//  InMemoryDayCoverRepository.swift
//  LifeGrid
//
//  Created by JJ on 7/9/2026.
//

import Foundation

/// Stores a student's Day Covers in memory while the app is running.
///
/// This repository supports the first MVP and makes the Day Cover business rules easy to test without requiring a database.

final class InMemoryDayCoverRepository: DayCoverRepository {
    private var storedDayCovers: [DayCover]
    private let calendar: Calendar

    init(
        storedDayCovers: [DayCover] = [],
        calendar: Calendar = .current
    ) {
        self.storedDayCovers = storedDayCovers
        self.calendar = calendar
    }

    func dayCover(for day: Date) -> DayCover? {
        storedDayCovers.first { dayCover in
            calendar.isDate(dayCover.day, inSameDayAs: day)
        }
    }

    func save(_ dayCover: DayCover) {
        storedDayCovers.append(dayCover)
    }

    func allDayCovers() -> [DayCover] {
        storedDayCovers.sorted { firstCover, secondCover in
            firstCover.day > secondCover.day
        }
    }
}
