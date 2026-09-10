import Foundation

/// Stores Time Capsules for the duration of the MVP app session.
final class InMemoryTimeCapsuleRepository: TimeCapsuleRepository {
    private var storedCapsules: [TimeCapsuleMessage]

    init(storedCapsules: [TimeCapsuleMessage] = []) {
        self.storedCapsules = storedCapsules
    }

    func save(_ capsule: TimeCapsuleMessage) {
        storedCapsules.append(capsule)
    }

    func allTimeCapsules() -> [TimeCapsuleMessage] {
        storedCapsules.sorted { $0.opensAt < $1.opensAt }
    }
}
