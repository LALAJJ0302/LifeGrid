import Foundation

/// Editing preserves identity and date; creation still rejects duplicates.
struct UpdateDayCoverUseCase {
    let repository: any DayCoverRepository
    var calendar: Calendar = .current

    func execute(dayCover: DayCover, today: Date = .now) throws {
        guard dayCover.hasMeaningfulContent else { throw CreateDayCoverError.emptyCover }
        guard calendar.startOfDay(for: dayCover.day) <= calendar.startOfDay(for: today) else {
            throw CreateDayCoverError.futureDateNotAllowed
        }
        guard let existing = repository.dayCover(for: dayCover.day),
              existing.id == dayCover.id, existing.day == dayCover.day,
              existing.createdAt == dayCover.createdAt else {
            throw CreateDayCoverError.dayAlreadyHasCover
        }
        repository.update(dayCover)
    }
}
