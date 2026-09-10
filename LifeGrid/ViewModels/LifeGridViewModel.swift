import Foundation
import Combine

/// Connects age entry and the LifeGrid creation rules to SwiftUI.
@MainActor
final class LifeGridViewModel: ObservableObject {
    @Published var ageText = ""
    @Published private(set) var profile: LifeGridProfile?
    @Published var alert: AppMessage?

    private let createLifeGrid: CreateLifeGridUseCase
    private let defaults: UserDefaults
    private let savedAgeKey = "lifeGrid.currentAge"

    init(
        createLifeGrid: CreateLifeGridUseCase? = nil,
        defaults: UserDefaults = .standard
    ) {
        let useCase = createLifeGrid ?? CreateLifeGridUseCase()
        self.createLifeGrid = useCase
        self.defaults = defaults

        if defaults.object(forKey: savedAgeKey) != nil {
            let savedAge = defaults.integer(forKey: savedAgeKey)
            profile = try? useCase.execute(currentAge: savedAge)
        }
    }

    func buildLifeGrid() {
        guard let age = Int(ageText.trimmingCharacters(in: .whitespaces)) else {
            alert = AppMessage(
                title: "Enter your age",
                details: "Use a whole number between 1 and 100. You can change it later."
            )
            return
        }

        do {
            let createdProfile = try createLifeGrid.execute(currentAge: age)
            profile = createdProfile
            defaults.set(age, forKey: savedAgeKey)
        } catch let error as CreateLifeGridError {
            alert = error.appMessage
        } catch {
            alert = AppMessage(title: "We couldn't create your LifeGrid", details: "Check your age and try again.")
        }
    }

    func changeAge() {
        if let currentAge = profile?.currentAge {
            ageText = String(currentAge)
        }
        profile = nil
        defaults.removeObject(forKey: savedAgeKey)
    }
}
