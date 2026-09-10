import SwiftUI

/// Collects saved moments, moods, kindness, and a short weekly reflection.
struct MemoryJarView: View {
    @ObservedObject var memoryViewModel: WeeklyMemoryViewModel
    @ObservedObject var kindnessViewModel: KindnessPromptViewModel
    @AppStorage("lifeGrid.weeklyReflection") private var weeklyReflection = ""
    @State private var savedConfirmation = false

    var body: some View {
        NavigationStack {
            ZStack {
                LifeGridTheme.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("A gentle look back at the moments you chose to keep.")
                            .font(.subheadline)
                            .foregroundStyle(LifeGridTheme.secondaryInk)

                        summaryCard
                        memoriesCard
                        reflectionCard
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 30)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("Memory Jar")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert("Reflection Saved", isPresented: $savedConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You can return and update it whenever you need.")
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("This Week", systemImage: "shippingbox.fill")
                .font(.headline)
                .foregroundStyle(LifeGridTheme.mint)
            HStack(spacing: 10) {
                summary(value: memoryViewModel.savedCovers.count, label: "moments", colour: LifeGridTheme.peachSoft)
                summary(value: memoryViewModel.savedCovers.filter { $0.mood != nil }.count, label: "moods", colour: LifeGridTheme.lavenderSoft)
                summary(value: kindnessViewModel.prompt.isCompleted ? 1 : 0, label: "kind act", colour: LifeGridTheme.mintSoft)
            }
        }
        .lifeGridCard()
    }

    private func summary(value: Int, label: String, colour: Color) -> some View {
        VStack(spacing: 5) {
            Text(value.formatted()).font(.title2.bold())
            Text(label).font(.caption).foregroundStyle(LifeGridTheme.secondaryInk)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(colour, in: RoundedRectangle(cornerRadius: 15))
    }

    private var memoriesCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Saved Moments")
                .font(.headline)
                .foregroundStyle(LifeGridTheme.ink)

            if memoryViewModel.savedCovers.isEmpty {
                HStack(spacing: 13) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(LifeGridTheme.peach)
                    Text("Your jar is ready for its first drawing, mood, or sentence.")
                        .font(.subheadline)
                        .foregroundStyle(LifeGridTheme.secondaryInk)
                }
                .padding(.vertical, 8)
            } else {
                ForEach(memoryViewModel.savedCovers) { cover in
                    HStack(spacing: 13) {
                        Text(cover.mood?.emoji ?? "✏️")
                            .font(.title2)
                            .frame(width: 46, height: 46)
                            .background(LifeGridTheme.peachSoft, in: Circle())
                        VStack(alignment: .leading, spacing: 3) {
                            Text(cover.mood?.displayName ?? "A drawn moment")
                                .font(.headline)
                            Text(cover.reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "A visual memory from this week" : cover.reflection)
                                .font(.caption)
                                .foregroundStyle(LifeGridTheme.secondaryInk)
                                .lineLimit(2)
                        }
                        Spacer()
                        Text(cover.day, format: .dateTime.weekday(.abbreviated))
                            .font(.caption2)
                            .foregroundStyle(LifeGridTheme.secondaryInk)
                    }
                    if cover.id != memoryViewModel.savedCovers.last?.id {
                        Divider()
                    }
                }
            }
        }
        .lifeGridCard()
    }

    private var reflectionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What mattered this week?")
                .font(.headline)
                .foregroundStyle(LifeGridTheme.ink)
            TextEditor(text: $weeklyReflection)
                .frame(minHeight: 120)
                .scrollContentBackground(.hidden)
                .padding(10)
                .background(.white, in: RoundedRectangle(cornerRadius: 15))
                .overlay(alignment: .topLeading) {
                    if weeklyReflection.isEmpty {
                        Text("One thing I want to carry forward...")
                            .foregroundStyle(LifeGridTheme.secondaryInk.opacity(0.55))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 18)
                            .allowsHitTesting(false)
                    }
                }
            Button("Save Weekly Reflection") {
                savedConfirmation = true
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .foregroundStyle(LifeGridTheme.ink)
            .background(LifeGridTheme.mintSoft, in: Capsule())
        }
        .lifeGridCard()
    }
}

#Preview {
    MemoryJarView(
        memoryViewModel: WeeklyMemoryViewModel(),
        kindnessViewModel: KindnessPromptViewModel()
    )
}
