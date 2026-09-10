import Foundation
import Combine

/// Connects the weekly kindness action and its completion rules to SwiftUI.
@MainActor
final class KindnessPromptViewModel: ObservableObject {
    @Published private(set) var prompt: KindnessPrompt
    @Published var alert: AppMessage?

    private let completePrompt: CompleteKindnessPromptUseCase

    init(repository: (any KindnessPromptRepository)? = nil) {
        let promptRepository = repository ?? InMemoryKindnessPromptRepository()
        prompt = KindnessPrompt(action: "Send a thank-you message to someone who helped you.")
        completePrompt = CompleteKindnessPromptUseCase(repository: promptRepository)
    }

    func markAsComplete() {
        do {
            prompt = try completePrompt.execute(prompt: prompt)
            alert = AppMessage(
                title: "A kind moment added",
                details: "One meaningful action is enough for this week."
            )
        } catch let error as CompleteKindnessPromptError {
            alert = error.appMessage
        } catch {
            alert = AppMessage(title: "We couldn't record this action", details: "Your intention still matters. Please try again.")
        }
    }
}
