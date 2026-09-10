import SwiftUI

struct WeeklyMemoryView: View {
    @ObservedObject var viewModel: WeeklyMemoryViewModel
    var body: some View {
        NavigationStack {
            DrawDayCoverView(viewModel: viewModel, date: Calendar.current.startOfDay(for: .now))
        }
    }
}

extension MoodSticker {
    var emoji: String {
        switch self {
        case .happy: "😊"
        case .excited: "🤩"
        case .grateful: "🙏"
        case .proud: "🌟"
        case .calm: "😌"
        case .hopeful: "🌱"
        case .loved: "🥰"
        case .motivated: "🔥"
        case .neutral: "😐"
        case .tired: "😴"
        case .bored: "🥱"
        case .confused: "😕"
        case .stressed: "😣"
        case .anxious: "😟"
        case .sad: "😢"
        case .overwhelmed: "🌊"
        }
    }
}

