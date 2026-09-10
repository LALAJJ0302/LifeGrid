import SwiftUI

struct ContentView: View {
    @StateObject private var lifeGridViewModel: LifeGridViewModel
    @StateObject private var memoryViewModel: WeeklyMemoryViewModel
    @StateObject private var kindnessViewModel: KindnessPromptViewModel
    @StateObject private var timeCapsuleViewModel: TimeCapsuleViewModel

    init() {
        _lifeGridViewModel = StateObject(wrappedValue: LifeGridViewModel())
        _memoryViewModel = StateObject(wrappedValue: WeeklyMemoryViewModel())
        _kindnessViewModel = StateObject(wrappedValue: KindnessPromptViewModel())
        _timeCapsuleViewModel = StateObject(wrappedValue: TimeCapsuleViewModel())
    }

    var body: some View {
        Group {
            if let profile = lifeGridViewModel.profile {
                LifeGridMainView(
                    profile: profile,
                    lifeGridViewModel: lifeGridViewModel,
                    memoryViewModel: memoryViewModel,
                    kindnessViewModel: kindnessViewModel,
                    timeCapsuleViewModel: timeCapsuleViewModel
                )
            } else {
                AgeInputView(viewModel: lifeGridViewModel)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: lifeGridViewModel.profile != nil)
    }
}

private enum LifeGridTab: Hashable {
    case life
    case draw
    case jar
    case capsule
    case memories
}

private struct LifeGridMainView: View {
    let profile: LifeGridProfile
    @ObservedObject var lifeGridViewModel: LifeGridViewModel
    @ObservedObject var memoryViewModel: WeeklyMemoryViewModel
    @ObservedObject var kindnessViewModel: KindnessPromptViewModel
    @ObservedObject var timeCapsuleViewModel: TimeCapsuleViewModel
    @State private var selectedTab: LifeGridTab = .life

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(
                profile: profile,
                memoryViewModel: memoryViewModel,
                kindnessViewModel: kindnessViewModel,
                onDrawThisWeek: { selectedTab = .draw },
                onOpenMemoryJar: { selectedTab = .jar },
                onChangeAge: lifeGridViewModel.changeAge
            )
            .tabItem { Label("Life", systemImage: "square.grid.3x3.fill") }
            .tag(LifeGridTab.life)

            WeeklyMemoryView(viewModel: memoryViewModel)
                .tabItem { Label("Draw", systemImage: "pencil.tip.crop.circle") }
                .tag(LifeGridTab.draw)

            MemoryJarView(
                memoryViewModel: memoryViewModel,
                kindnessViewModel: kindnessViewModel
            )
            .tabItem { Label("Memory Jar", systemImage: "shippingbox.fill") }
            .tag(LifeGridTab.jar)

            NavigationStack {
                MemoryTimelineView(memoryViewModel: memoryViewModel)
            }
            .tabItem { Label("Memories", systemImage: "calendar") }
            .tag(LifeGridTab.memories)

            TimeCapsuleView(viewModel: timeCapsuleViewModel)
                .tabItem { Label("Capsule", systemImage: "envelope.badge.clock.fill") }
                .tag(LifeGridTab.capsule)
        }
        .tint(LifeGridTheme.peach)
        .toolbarBackground(LifeGridTheme.surface, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    ContentView()
}
