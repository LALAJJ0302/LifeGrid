import Foundation
import Testing
@testable import LifeGrid

@MainActor
struct CompleteKindnessPromptUseCaseTests {
    private let calendar = Calendar(identifier: .gregorian)

    @Test
    func completeKindnessPrompt_succeeds_whenWeekHasNoRecordedAction() throws {
        let repository = InMemoryKindnessPromptRepository(calendar: calendar)
        let useCase = CompleteKindnessPromptUseCase(repository: repository)
        let prompt = KindnessPrompt(action: "Thank someone who helped you.")
        let date = makeDate(day: 9)

        let completed = try useCase.execute(prompt: prompt, completedAt: date)

        #expect(completed.isCompleted)
        #expect(repository.allCompletedPrompts() == [completed])
    }

    @Test
    func completeKindnessPrompt_fails_whenPromptWasAlreadyCompleted() {
        let date = makeDate(day: 9)
        let completed = KindnessPrompt(action: "Call your family.", completedAt: date)
        let repository = InMemoryKindnessPromptRepository(storedCompletedPrompts: [completed], calendar: calendar)
        let useCase = CompleteKindnessPromptUseCase(repository: repository)

        #expect(throws: CompleteKindnessPromptError.promptAlreadyCompleted) {
            try useCase.execute(prompt: completed, completedAt: date)
        }
    }

    @Test
    func completeKindnessPrompt_fails_whenAnotherActionExistsInSameWeek() {
        let first = KindnessPrompt(action: "Help a classmate.", completedAt: makeDate(day: 8))
        let repository = InMemoryKindnessPromptRepository(storedCompletedPrompts: [first], calendar: calendar)
        let useCase = CompleteKindnessPromptUseCase(repository: repository)
        let second = KindnessPrompt(action: "Give someone a sincere compliment.")

        #expect(throws: CompleteKindnessPromptError.weeklyCompletionLimitReached) {
            try useCase.execute(prompt: second, completedAt: makeDate(day: 10))
        }
        #expect(repository.allCompletedPrompts().count == 1)
    }

    private func makeDate(day: Int) -> Date {
        calendar.date(from: DateComponents(year: 2026, month: 9, day: day, hour: 12))!
    }
}
