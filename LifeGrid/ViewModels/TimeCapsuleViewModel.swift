import Foundation
import Combine

/// Connects Time Capsule form input to the domain creation rules.
@MainActor
final class TimeCapsuleViewModel: ObservableObject {
    @Published var message = ""
    @Published var opensAt: Date
    @Published private(set) var capsules: [TimeCapsuleMessage] = []
    @Published var alert: AppMessage?

    private let repository: any TimeCapsuleRepository
    private let createTimeCapsule: CreateTimeCapsuleUseCase

    init(repository: (any TimeCapsuleRepository)? = nil) {
        let capsuleRepository = repository ?? InMemoryTimeCapsuleRepository()
        self.repository = capsuleRepository
        createTimeCapsule = CreateTimeCapsuleUseCase(repository: capsuleRepository)
        opensAt = Calendar.current.date(byAdding: .month, value: 1, to: .now) ?? .now.addingTimeInterval(86_400)
        capsules = capsuleRepository.allTimeCapsules()
    }

    func sealCapsule() {
        do {
            try createTimeCapsule.execute(message: message, opensAt: opensAt)
            capsules = repository.allTimeCapsules()
            message = ""
            alert = AppMessage(
                title: "Time Capsule sealed",
                details: "It will be ready for you on \(opensAt.formatted(date: .abbreviated, time: .omitted))."
            )
        } catch let error as CreateTimeCapsuleError {
            alert = error.appMessage
        } catch {
            alert = AppMessage(title: "We couldn't seal this capsule", details: "Your message is still here. Please try again.")
        }
    }
}
