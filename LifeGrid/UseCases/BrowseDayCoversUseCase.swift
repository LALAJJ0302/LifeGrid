import Foundation

struct BrowseDayCoversUseCase {
    let repository: any DayCoverRepository
    var calendar: Calendar = .current

    func execute(period: MemoryPeriod, containing date: Date) throws -> [DayCover] {
        guard let interval = calendar.dateInterval(of: period.calendarComponent, for: date) else {
            throw BrowseDayCoversError.dateRangeUnavailable
        }
        return repository.dayCovers(in: interval)
    }
}
