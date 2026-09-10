//
//  DayCoverRepository.swift
//  LifeGrid
//
//  Created by JJ on 7/9/2026.
//

import Foundation

/// Describes the storage operations required to manage a student's Day Covers.
///
/// The repository allows the app to save memories and find whether a cover already exists for a particular calendar day.
///
protocol DayCoverRepository {
    /// Returns the Day Cover saved for the specified day, if one exists.
    func dayCover(for day: Date) -> DayCover?

    /// Start inclusive, end exclusive, ordered earliest first.
    func dayCovers(in interval: DateInterval) -> [DayCover]

    /// Replaces the cover with the same identity when editing.
    func update(_ dayCover: DayCover)

    /// Saves a new Day Cover.
    func save(_ dayCover: DayCover)

    /// Returns every Day Cover currently stored in the Life Grid.
    func allDayCovers() -> [DayCover]
}
