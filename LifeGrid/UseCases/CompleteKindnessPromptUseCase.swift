import Foundation

/// Records one meaningful kindness action within a student's current week.
struct CompleteKindnessPromptUseCase {
    private let repository: any KindnessPromptRepository

    init(repository: any KindnessPromptRepository) {
        self.repository = repository
    }

    @discardableResult
    func execute(prompt: KindnessPrompt, completedAt: Date = .now) throws -> KindnessPrompt {
        guard !prompt.isCompleted,
              repository.completedPrompt(withID: prompt.id) == nil else {
            throw CompleteKindnessPromptError.promptAlreadyCompleted
        }

        guard repository.completedPrompt(inWeekContaining: completedAt) == nil else {
            throw CompleteKindnessPromptError.weeklyCompletionLimitReached
        }

        let completedPrompt = KindnessPrompt(id: prompt.id, action: prompt.action, completedAt: completedAt)
        repository.saveCompleted(completedPrompt)
        return completedPrompt
    }
}
