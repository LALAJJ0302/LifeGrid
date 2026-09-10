//
//  DayCover.swift
//  LifeGrid
//
//  Created by JJ on 7/9/2026.
//

import Foundation

/// Represents one visual memory created for a specific day.
///
/// A Day Cover allows a student to preserve a day using a drawing, a mood sticker, or a short written reflection.
///
/// Business Rules:
/// - A student can save only one primary Day Cover per calendar day.
/// - A Day Cover must contain a drawing, mood, or reflection before saving.
/// - A reflection is optional because LifeGrid supports low-pressure journaling.

struct DayCover: Identifiable, Codable, Equatable {
    let id: UUID
    let day: Date
    var artwork: DayCoverArtwork?
    var mood: MoodSticker?
    var reflection: String
    let createdAt: Date

    init(
        id: UUID = UUID(),
        day: Date,
        artwork: DayCoverArtwork? = nil,
        mood: MoodSticker? = nil,
        reflection: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.day = day
        self.artwork = artwork
        self.mood = mood
        self.reflection = reflection
        self.createdAt = createdAt
    }

    var hasMeaningfulContent: Bool {
        let trimmedReflection = reflection.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let containsDrawing = artwork != nil
        let containsMood = mood != nil
        let containsReflection = !trimmedReflection.isEmpty

        return containsDrawing || containsMood || containsReflection
    }
}
