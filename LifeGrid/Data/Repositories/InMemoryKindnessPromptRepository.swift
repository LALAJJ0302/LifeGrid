import Foundation

/// Stores completed Kindness Prompts during the MVP app session.
final class InMemoryKindnessPromptRepository: KindnessPromptRepository {
    private var storedCompletedPrompts: [KindnessPrompt]
    private let calendar: Calendar

    init(storedCompletedPrompts: [KindnessPrompt] = [], calendar: Calendar = .current) {
        self.storedCompletedPrompts = storedCompletedPrompts
        self.calendar = calendar
    }

    func completedPrompt(withID id: UUID) -> KindnessPrompt? {
        storedCompletedPrompts.first { $0.id == id && $0.isCompleted }
    }

    func completedPrompt(inWeekContaining date: Date) -> KindnessPrompt? {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: date) else { return nil }
        return storedCompletedPrompts.first { prompt in
            guard let completedAt = prompt.completedAt else { return false }
            return week.contains(completedAt)
        }
    }

    func saveCompleted(_ prompt: KindnessPrompt) {
        storedCompletedPrompts.append(prompt)
    }

    func allCompletedPrompts() -> [KindnessPrompt] {
        storedCompletedPrompts
            .filter(\.isCompleted)
            .sorted { ($0.completedAt ?? .distantPast) > ($1.completedAt ?? .distantPast) }
    }
}
