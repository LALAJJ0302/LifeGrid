import Foundation

/// Describes storage operations for messages written to a future self.
protocol TimeCapsuleRepository {
    func save(_ capsule: TimeCapsuleMessage)
    func allTimeCapsules() -> [TimeCapsuleMessage]
}
