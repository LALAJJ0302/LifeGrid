//
//  MoodSticker.swift
//  LifeGrid
//
//  Created by JJ on 7/9/2026.
//
import Foundation

/// Represents the mood a student attaches to a daily visual memory.
///
/// A mood sticker gives the student a quick way to reflect without requiring them to write a long journal entry.
///
/// Business Rule: A Day Cover can contain no more than one mood sticker.

enum MoodSticker: String, CaseIterable, Codable, Identifiable {
    case happy
    case excited
    case grateful
    case proud

    case calm
    case hopeful
    case loved
    case motivated

    case neutral
    case tired
    case bored
    case confused

    case stressed
    case anxious
    case sad
    case overwhelmed

    var id: String {
        rawValue
    }

    var displayName: String {
        rawValue.capitalized
    }
}
