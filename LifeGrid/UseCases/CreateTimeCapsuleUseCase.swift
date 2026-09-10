import Foundation

/// Validates and seals a message that a student wants to revisit later.
struct CreateTimeCapsuleUseCase {
    private let repository: any TimeCapsuleRepository

    init(repository: any TimeCapsuleRepository) {
        self.repository = repository
    }

    @discardableResult
    func execute(
        message: String,
        opensAt: Date,
        createdAt: Date = .now,
        linkedDayCoverID: UUID? = nil
    ) throws -> TimeCapsuleMessage {
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedMessage.isEmpty else {
            throw CreateTimeCapsuleError.emptyMessage
        }

        guard opensAt > createdAt else {
            throw CreateTimeCapsuleError.openingDateNotFuture
        }

        let capsule = TimeCapsuleMessage(
            message: trimmedMessage,
            createdAt: createdAt,
            opensAt: opensAt,
            linkedDayCoverID: linkedDayCoverID
        )
        repository.save(capsule)
        return capsule
    }
}
