import Foundation

/// Represents one small act of kindness suggested to a student.
///
/// Business Rules:
/// - A prompt describes one clear and achievable action.
/// - The same prompt can be completed only once.
/// - A student records no more than one main kindness action each week.
struct KindnessPrompt: Identifiable, Codable, Equatable {
    let id: UUID
    let action: String
    var completedAt: Date?

    init(id: UUID = UUID(), action: String, completedAt: Date? = nil) {
        self.id = id
        self.action = action
        self.completedAt = completedAt
    }

    var isCompleted: Bool { completedAt != nil }
}
