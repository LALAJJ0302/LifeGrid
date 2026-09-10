import Foundation
import Testing
@testable import LifeGrid

@MainActor
struct CreateTimeCapsuleUseCaseTests {
    private let now = Date(timeIntervalSince1970: 1_800_000_000)

    @Test
    func createTimeCapsule_succeeds_whenMessageAndFutureDateAreValid() throws {
        let repository = InMemoryTimeCapsuleRepository()
        let useCase = CreateTimeCapsuleUseCase(repository: repository)
        let future = now.addingTimeInterval(86_400)

        let capsule = try useCase.execute(message: "Remember how far you came.", opensAt: future, createdAt: now)

        #expect(capsule.message == "Remember how far you came.")
        #expect(capsule.opensAt == future)
        #expect(repository.allTimeCapsules() == [capsule])
    }

    @Test
    func createTimeCapsule_fails_whenMessageIsEmpty() {
        let repository = InMemoryTimeCapsuleRepository()
        let useCase = CreateTimeCapsuleUseCase(repository: repository)

        #expect(throws: CreateTimeCapsuleError.emptyMessage) {
            try useCase.execute(message: "   ", opensAt: now.addingTimeInterval(86_400), createdAt: now)
        }
        #expect(repository.allTimeCapsules().isEmpty)
    }

    @Test
    func createTimeCapsule_fails_whenOpeningDateIsNotFuture() {
        let repository = InMemoryTimeCapsuleRepository()
        let useCase = CreateTimeCapsuleUseCase(repository: repository)

        #expect(throws: CreateTimeCapsuleError.openingDateNotFuture) {
            try useCase.execute(message: "Keep going.", opensAt: now, createdAt: now)
        }
        #expect(repository.allTimeCapsules().isEmpty)
    }
}
