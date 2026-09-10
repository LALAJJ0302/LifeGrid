import SwiftUI

/// Shows the student's 80-year weekly frame and current reflection actions.
struct DashboardView: View {
    let profile: LifeGridProfile
    @ObservedObject var memoryViewModel: WeeklyMemoryViewModel
    @ObservedObject var kindnessViewModel: KindnessPromptViewModel
    let onDrawThisWeek: () -> Void
    let onOpenMemoryJar: () -> Void
    let onChangeAge: () -> Void
    @State private var selectedWeek: Date?


    var body: some View {
        NavigationStack {
            ZStack {
                LifeGridTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        header
                        perspectiveCard
                        weekGridCard
                        thisWeekCard
                        kindnessCard
                        recentMemoryCard
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 30)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .alert(item: $kindnessViewModel.alert) { message in
            Alert(title: Text(message.title), message: Text(message.details), dismissButton: .default(Text("OK")))
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("LifeGrid")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(LifeGridTheme.ink)
                Text("Draw your time. Keep what matters.")
                    .foregroundStyle(LifeGridTheme.secondaryInk)
            }
            Spacer()
            Button(action: onChangeAge) {
                Image(systemName: "person.crop.circle")
                    .font(.title2)
                    .foregroundStyle(LifeGridTheme.ink)
                    .padding(9)
                    .background(LifeGridTheme.surface, in: Circle())
            }
            .accessibilityLabel("Change age")
        }
        .padding(.top, 12)
    }

    private var perspectiveCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your time, in weeks")
                .font(.title2.bold())
                .foregroundStyle(LifeGridTheme.ink)

            HStack(spacing: 8) {
                metric(value: profile.totalWeeksInFrame.formatted(), label: "in the frame", colour: LifeGridTheme.lavenderSoft)
                metric(value: "About \(profile.weeksLivedWithinFrame.formatted())", label: "lived", colour: LifeGridTheme.peachSoft)
                metric(value: "About \(profile.remainingWeeksInFrame.formatted())", label: "ahead", colour: LifeGridTheme.mintSoft)
            }

            Text("This is a reflection frame, not a prediction of how long anyone will live.")
                .font(.caption)
                .foregroundStyle(LifeGridTheme.secondaryInk)
        }
        .lifeGridCard()
    }

    private func metric(value: String, label: String, colour: Color) -> some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.subheadline.bold())
                .minimumScaleFactor(0.72)
                .lineLimit(1)
            Text(label)
                .font(.caption2)
                .foregroundStyle(LifeGridTheme.secondaryInk)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(colour, in: RoundedRectangle(cornerRadius: 15))
    }

    private var weekGridCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("80 years · 4,160 weeks")
                        .font(.headline)
                    Text("Each small mark represents one week.")
                        .font(.caption)
                        .foregroundStyle(LifeGridTheme.secondaryInk)
                }
                Spacer()
                Image(systemName: "square.grid.3x3.fill")
                    .foregroundStyle(LifeGridTheme.peach)
            }

            GeometryReader { geometry in
                LifeWeeksGridView(profile: profile)
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        let column = min(51, max(0, Int(location.x / geometry.size.width * 52)))
                        let row = min(profile.lifespanFrameYears - 1, max(0, Int(location.y / geometry.size.height * CGFloat(profile.lifespanFrameYears))))
                        let offset = row * 52 + column - profile.weeksLivedWithinFrame
                        selectedWeek = Calendar.current.date(byAdding: .weekOfYear, value: offset, to: .now)
                    }
            }
            .aspectRatio(52.0 / 80.0, contentMode: .fit)
            .sheet(isPresented: Binding(get: { selectedWeek != nil }, set: { if !$0 { selectedWeek = nil } })) {
                if let selectedWeek {
                    NavigationStack {
                        MemoryTimelineView(memoryViewModel: memoryViewModel, anchorDate: selectedWeek, period: .week)
                    }
                }
            }
            Text("Tap a week to browse memories. Week dates are estimated from your age.")
                .font(.caption)


            HStack(spacing: 14) {
                legend(colour: LifeGridTheme.peach, text: "Weeks lived")
                legend(colour: LifeGridTheme.mint, text: "This week")
                legend(colour: LifeGridTheme.lavenderSoft, text: "Weeks ahead")
            }
        }
        .lifeGridCard()
    }

    private func legend(colour: Color, text: String) -> some View {
        Label {
            Text(text).font(.caption2)
        } icon: {
            Circle().fill(colour).frame(width: 8, height: 8)
        }
    }

    private var thisWeekCard: some View {
        VStack(alignment: .leading, spacing: 13) {
            Label("This Week", systemImage: "pencil.and.scribble")
                .font(.headline)
                .foregroundStyle(LifeGridTheme.peach)
            Text(memoryViewModel.savedCovers.isEmpty ? "What would you like to remember?" : "You saved \(memoryViewModel.savedCovers.count) moment this week.")
                .font(.title3.bold())
                .foregroundStyle(LifeGridTheme.ink)
            Text("A small drawing, one mood, or a short sentence is enough.")
                .font(.subheadline)
                .foregroundStyle(LifeGridTheme.secondaryInk)
            Button(action: onDrawThisWeek) {
                Label("Draw This Week", systemImage: "pencil.tip")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .background(LifeGridTheme.peach, in: Capsule())
        }
        .lifeGridCard()
    }

    private var kindnessCard: some View {
        VStack(alignment: .leading, spacing: 13) {
            Label("This Week's Kindness Prompt", systemImage: "heart.fill")
                .font(.headline)
                .foregroundStyle(LifeGridTheme.lavender)
            Text(kindnessViewModel.prompt.action)
                .font(.title3.bold())
                .foregroundStyle(LifeGridTheme.ink)
            Text("One meaningful action is enough for this week.")
                .font(.subheadline)
                .foregroundStyle(LifeGridTheme.secondaryInk)
            Button(action: kindnessViewModel.markAsComplete) {
                Label(kindnessViewModel.prompt.isCompleted ? "Completed" : "Mark as Complete", systemImage: kindnessViewModel.prompt.isCompleted ? "checkmark.circle.fill" : "heart")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
            }
            .buttonStyle(.plain)
            .foregroundStyle(LifeGridTheme.ink)
            .background(LifeGridTheme.lavenderSoft, in: Capsule())
        }
        .lifeGridCard()
    }

    private var recentMemoryCard: some View {
        Button(action: onOpenMemoryJar) {
            HStack(spacing: 14) {
                Image(systemName: "shippingbox.fill")
                    .font(.title2)
                    .foregroundStyle(LifeGridTheme.mint)
                    .frame(width: 46, height: 46)
                    .background(LifeGridTheme.mintSoft, in: Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weekly Memory Jar")
                        .font(.headline)
                    Text(memoryViewModel.savedCovers.isEmpty ? "Your first memory is waiting." : "Open your saved moments and reflection.")
                        .font(.subheadline)
                        .foregroundStyle(LifeGridTheme.secondaryInk)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(LifeGridTheme.secondaryInk)
            }
            .foregroundStyle(LifeGridTheme.ink)
            .lifeGridCard()
        }
        .buttonStyle(.plain)
    }
}

private struct LifeWeeksGridView: View {
    let profile: LifeGridProfile

    var body: some View {
        Canvas { context, size in
            let columns = 52
            let rows = profile.lifespanFrameYears
            let spacing: CGFloat = 1.35
            let cellWidth = (size.width - CGFloat(columns - 1) * spacing) / CGFloat(columns)
            let cellHeight = (size.height - CGFloat(rows - 1) * spacing) / CGFloat(rows)

            for index in 0..<profile.totalWeeksInFrame {
                let column = index % columns
                let row = index / columns
                let rect = CGRect(
                    x: CGFloat(column) * (cellWidth + spacing),
                    y: CGFloat(row) * (cellHeight + spacing),
                    width: cellWidth,
                    height: cellHeight
                )
                let colour: Color
                if index < profile.weeksLivedWithinFrame {
                    colour = LifeGridTheme.peach
                } else if index == min(profile.weeksLivedWithinFrame, profile.totalWeeksInFrame - 1) {
                    colour = LifeGridTheme.mint
                } else {
                    colour = LifeGridTheme.lavenderSoft
                }
                context.fill(Path(roundedRect: rect, cornerRadius: max(0.8, cellWidth * 0.28)), with: .color(colour))
            }
        }
        .aspectRatio(52.0 / 80.0, contentMode: .fit)
        .accessibilityLabel("Life grid with \(profile.totalWeeksInFrame) weeks")
        .accessibilityValue("About \(profile.weeksLivedWithinFrame) weeks lived and \(profile.remainingWeeksInFrame) weeks ahead in the reflection frame")
    }
}

#Preview {
    DashboardView(
        profile: LifeGridProfile(currentAge: 21),
        memoryViewModel: WeeklyMemoryViewModel(),
        kindnessViewModel: KindnessPromptViewModel(),
        onDrawThisWeek: {},
        onOpenMemoryJar: {},
        onChangeAge: {}
    )
}
