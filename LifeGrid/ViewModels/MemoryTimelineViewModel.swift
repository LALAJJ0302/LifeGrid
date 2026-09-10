import Foundation
import Combine

@MainActor
final class MemoryTimelineViewModel: ObservableObject {
    @Published var selectedPeriod: MemoryPeriod = .month
    @Published var anchorDate: Date = .now
    @Published private(set) var dayCovers: [DayCover] = []
    @Published var alert: AppMessage?
    let calendar: Calendar
    private let browseDayCovers: BrowseDayCoversUseCase

    init(browseDayCovers: BrowseDayCoversUseCase, calendar: Calendar = .current) {
        self.browseDayCovers = browseDayCovers
        self.calendar = calendar
    }

    func loadMemories() {
        do {
            dayCovers = try browseDayCovers.execute(period: selectedPeriod, containing: anchorDate)
            alert = nil
        } catch {
            dayCovers = []
            alert = (error as? BrowseDayCoversError)?.appMessage
                ?? AppMessage(title: "Memories unavailable", details: "Choose another period and try again.")
        }
    }

    func movePeriod(by value: Int) {
        guard let date = calendar.date(byAdding: selectedPeriod.calendarComponent, value: value, to: anchorDate) else { return }
        anchorDate = date
        loadMemories()
    }

    func dayCover(for date: Date) -> DayCover? {
        dayCovers.first { calendar.isDate($0.day, inSameDayAs: date) }
    }

    func dates(in period: MemoryPeriod, containing date: Date) -> [Date] {
        guard let interval = calendar.dateInterval(of: period.calendarComponent, for: date) else { return [] }
        var dates: [Date] = []
        var cursor = interval.start
        while cursor < interval.end {
            dates.append(cursor)
            guard let next = calendar.date(byAdding: .day, value: 1, to: cursor), next > cursor else { break }
            cursor = next
        }
        return dates
    }
}
