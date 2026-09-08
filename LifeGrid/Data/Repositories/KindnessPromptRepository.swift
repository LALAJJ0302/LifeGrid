//
//  KindnessPromptRepository..swift
//  LifeGrid
//
//  Created by JJ on 8/9/2026.
//

import Foundation

/// Describes the storage operations required to record completed Kindness Prompts.
///
/// The repository allows the app to check whether a student has already completed a prompt on a particular calendar day.

protocol KindnessPromptRepository {
    /// Returns the Kindness Prompt completed on the specified day, if one exists.
    func completedPrompt(on day: Date) -> KindnessPrompt?

    /// Saves a completed Kindness Prompt.
    func saveCompleted(_ prompt: KindnessPrompt)

    /// Returns every completed Kindness Prompt.
    func allCompletedPrompts() -> [KindnessPrompt]
}
