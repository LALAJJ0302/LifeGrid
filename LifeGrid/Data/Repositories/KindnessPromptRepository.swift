import Foundation

/// Describes storage operations for completed weekly Kindness Prompts.
protocol KindnessPromptRepository {
    func completedPrompt(withID id: UUID) -> KindnessPrompt?
    func completedPrompt(inWeekContaining date: Date) -> KindnessPrompt?
    func saveCompleted(_ prompt: KindnessPrompt)
    func allCompletedPrompts() -> [KindnessPrompt]
}
