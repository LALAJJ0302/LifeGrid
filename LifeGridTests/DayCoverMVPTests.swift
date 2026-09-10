import Foundation
import Testing
import PencilKit
import UIKit
@testable import LifeGrid

@MainActor
struct DayCoverMVPTests {
    private var calendar: Calendar {
        var value = Calendar(identifier: .gregorian)
        value.timeZone = TimeZone(identifier: "Australia/Sydney")!
        value.firstWeekday = 2
        return value
    }
    private func date(_ day: Int, month: Int = 9, hour: Int = 0) -> Date {
        calendar.date(from: DateComponents(year: 2026, month: month, day: day, hour: hour))!
    }
    private func drawing() -> PKDrawing {
        let points = [CGPoint(x: 20, y: 20), CGPoint(x: 80, y: 80)].enumerated().map { index, point in
            PKStrokePoint(location: point, timeOffset: Double(index) * 0.1,
                          size: CGSize(width: 6, height: 6), opacity: 1, force: 1, azimuth: 0, altitude: .pi / 2)
        }
        return PKDrawing(strokes: [PKStroke(ink: PKInk(.pen, color: .orange),
            path: PKStrokePath(controlPoints: points, creationDate: date(10)))])
    }

    @Test func createDayCover_succeeds_whenDrawingIsPresent() throws {
        let repository = InMemoryDayCoverRepository(calendar: calendar)
        let artwork = try #require(DayCoverArtworkFactory.makeArtwork(from: drawing(), canvasSize: CGSize(width: 340, height: 300)))
        let cover = DayCover(day: date(10), artwork: artwork)
        try CreateDayCoverUseCase(repository: repository, calendar: calendar).execute(dayCover: cover, today: date(10))
        let saved = try #require(repository.dayCover(for: date(10)))
        #expect(saved == cover)
        #expect(try PKDrawing(data: artwork.editableDrawingData).strokes.count == 1)
        #expect(UIImage(data: artwork.thumbnailPNGData) != nil)
        #expect(try JSONDecoder().decode(DayCover.self, from: JSONEncoder().encode(saved)) == saved)
    }
    @Test func createDayCover_succeeds_whenOnlyMoodIsSelected() throws {
        let repository = InMemoryDayCoverRepository(calendar: calendar)
        let cover = DayCover(day: date(10), mood: .hopeful)
        try CreateDayCoverUseCase(repository: repository, calendar: calendar).execute(dayCover: cover, today: date(10))
        #expect(repository.dayCover(for: date(10)) == cover)
    }
    @Test func createDayCover_fails_whenCoverIsEmpty() {
        let repository = InMemoryDayCoverRepository(calendar: calendar)
        #expect(throws: CreateDayCoverError.emptyCover) {
            try CreateDayCoverUseCase(repository: repository, calendar: calendar)
                .execute(dayCover: DayCover(day: date(10), reflection: " \n\t "), today: date(10))
        }
        #expect(repository.allDayCovers().isEmpty)
        #expect(DayCoverArtworkFactory.makeArtwork(from: PKDrawing(), canvasSize: CGSize(width: 340, height: 300)) == nil)
    }
    @Test func createDayCover_fails_whenDateIsInFuture() {
        let repository = InMemoryDayCoverRepository(calendar: calendar)
        #expect(throws: CreateDayCoverError.futureDateNotAllowed) {
            try CreateDayCoverUseCase(repository: repository, calendar: calendar)
                .execute(dayCover: DayCover(day: date(11), mood: .calm), today: date(10, hour: 23))
        }
        #expect(repository.allDayCovers().isEmpty)
    }
    @Test func createDayCover_fails_whenSameCalendarDayAlreadyHasCover() throws {
        let repository = InMemoryDayCoverRepository(calendar: calendar)
        let useCase = CreateDayCoverUseCase(repository: repository, calendar: calendar)
        let existing = DayCover(day: date(10, hour: 8), mood: .happy)
        try useCase.execute(dayCover: existing, today: date(10, hour: 10))
        #expect(throws: CreateDayCoverError.dayAlreadyHasCover) {
            try useCase.execute(dayCover: DayCover(day: date(10, hour: 20), mood: .calm), today: date(10, hour: 10))
        }
        #expect(repository.allDayCovers() == [existing])
    }
    @Test func createDayCover_allowsLaterTimeTodayAndReflectionOnly() throws {
        let repository = InMemoryDayCoverRepository(calendar: calendar)
        try CreateDayCoverUseCase(repository: repository, calendar: calendar)
            .execute(dayCover: DayCover(day: date(10, hour: 20), reflection: "A memory"), today: date(10, hour: 10))
        #expect(repository.allDayCovers().count == 1)
    }
    @Test func browseDayCovers_returnsOnlyCoversInsideSelectedMonth() throws {
        let covers = [DayCover(day: date(31, month: 8), mood: .calm),
                      DayCover(day: date(1), mood: .calm), DayCover(day: date(30, hour: 23), mood: .happy),
                      DayCover(day: date(1, month: 10), mood: .happy)]
        let repository = InMemoryDayCoverRepository(storedDayCovers: covers, calendar: calendar)
        let result = try BrowseDayCoversUseCase(repository: repository, calendar: calendar).execute(period: .month, containing: date(10))
        #expect(result == Array(covers[1...2]))
    }
    @Test func browseDayCovers_returnsCoversInDateOrder() throws {
        let covers = [DayCover(day: date(20), mood: .happy), DayCover(day: date(1), mood: .happy), DayCover(day: date(10), mood: .happy)]
        let repository = InMemoryDayCoverRepository(storedDayCovers: covers, calendar: calendar)
        let result = try BrowseDayCoversUseCase(repository: repository, calendar: calendar).execute(period: .month, containing: date(10))
        #expect(result.map(\.day) == [date(1), date(10), date(20)])
    }
    @Test(arguments: MemoryPeriod.allCases)
    func browseDayCovers_excludesNextPeriodBoundary(period: MemoryPeriod) throws {
        let interval = try #require(calendar.dateInterval(of: period.calendarComponent, for: date(10)))
        let inside = DayCover(day: interval.start, mood: .calm)
        let outside = DayCover(day: interval.end, mood: .calm)
        let repository = InMemoryDayCoverRepository(storedDayCovers: [outside, inside], calendar: calendar)
        #expect(try BrowseDayCoversUseCase(repository: repository, calendar: calendar).execute(period: period, containing: date(10)) == [inside])
    }
    @Test func editing_preservesIdentityAndRejectsEmptyChanges() throws {
        let original = DayCover(day: date(10), mood: .calm)
        let repository = InMemoryDayCoverRepository(storedDayCovers: [original], calendar: calendar)
        let useCase = UpdateDayCoverUseCase(repository: repository, calendar: calendar)
        var edited = original
        edited.reflection = "Updated"
        try useCase.execute(dayCover: edited, today: date(10))
        #expect(repository.allDayCovers() == [edited])
        edited.mood = nil
        edited.reflection = " "
        #expect(throws: CreateDayCoverError.emptyCover) { try useCase.execute(dayCover: edited, today: date(10)) }
        #expect(repository.allDayCovers().first?.reflection == "Updated")
    }
    @Test func timeline_loadsMovesAndFindsSameDay() {
        let cover = DayCover(day: date(10, hour: 20), mood: .calm)
        let repository = InMemoryDayCoverRepository(storedDayCovers: [cover], calendar: calendar)
        let model = MemoryTimelineViewModel(browseDayCovers: BrowseDayCoversUseCase(repository: repository, calendar: calendar), calendar: calendar)
        model.anchorDate = date(10)
        model.loadMemories()
        #expect(model.dayCover(for: date(10)) == cover)
        model.movePeriod(by: 1)
        #expect(model.dayCovers.isEmpty)
        model.movePeriod(by: -1)
        #expect(model.dayCovers == [cover])
        #expect(model.dates(in: .week, containing: date(10)).count == 7)
        #expect(model.dates(in: .month, containing: date(10)).count == 30)
    }
}
