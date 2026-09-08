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

    init(repository: any DayCoverRepository) {
        self.repository = repository
    }

    @discardableResult
    func execute(dayCover: DayCover) throws -> DayCover {
        guard dayCover.hasMeaningfulContent else {
            throw CreateDayCoverError.emptyCover
        }

        guard repository.dayCover(for: dayCover.day) == nil else {
            throw CreateDayCoverError.dayAlreadyHasCover
        }

        repository.save(dayCover)

        return dayCover
    }
}
