import Foundation

/// Represents one small act of kindness suggested to a student.
///
/// A Kindness Prompt is intentionally simple so that it encourages
/// meaningful action without becoming another stressful task.
///
/// Business Rules:
/// - A prompt must describe one clear and achievable action.
/// - A prompt can be completed only once.
/// - A student can complete no more than one main prompt per calendar day.

struct KindnessPrompt: Identifiable, Codable, Equatable {
    let id: UUID
    let action: String
    var completedAt: Date?

    init(
        id: UUID = UUID(),
        action: String,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.action = action
        self.completedAt = completedAt
    }

    var isCompleted: Bool {
        completedAt != nil
    }
}
