import Foundation

/// Represents a private note written now for the student's future self.
///
/// Business Rules:
/// - A capsule must contain a meaningful message.
/// - Its opening date must be later than its creation date.
struct TimeCapsuleMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let message: String
    let createdAt: Date
    let opensAt: Date
    let linkedDayCoverID: UUID?

    init(
        id: UUID = UUID(),
        message: String,
        createdAt: Date,
        opensAt: Date,
        linkedDayCoverID: UUID? = nil
    ) {
        self.id = id
        self.message = message
        self.createdAt = createdAt
        self.opensAt = opensAt
        self.linkedDayCoverID = linkedDayCoverID
    }

    func canOpen(at date: Date = .now) -> Bool {
        date >= opensAt
    }
}
