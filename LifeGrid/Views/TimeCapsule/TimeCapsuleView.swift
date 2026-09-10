import SwiftUI

/// Lets a student seal a note that can be revisited on a future date.
struct TimeCapsuleView: View {
    @ObservedObject var viewModel: TimeCapsuleViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                LifeGridTheme.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        introCard
                        formCard
                        capsulesCard
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 30)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("Time Capsule")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert(item: $viewModel.alert) { message in
            Alert(title: Text(message.title), message: Text(message.details), dismissButton: .default(Text("OK")))
        }
    }

    private var introCard: some View {
        HStack(spacing: 16) {
            Image(systemName: "envelope.badge.clock.fill")
                .font(.system(size: 32))
                .foregroundStyle(LifeGridTheme.lavender)
                .frame(width: 62, height: 62)
                .background(LifeGridTheme.lavenderSoft, in: Circle())
            VStack(alignment: .leading, spacing: 5) {
                Text("A note for future you")
                    .font(.title3.bold())
                Text("Write something you would like to rediscover later.")
                    .font(.subheadline)
                    .foregroundStyle(LifeGridTheme.secondaryInk)
            }
        }
        .foregroundStyle(LifeGridTheme.ink)
        .lifeGridCard()
    }

    private var formCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your message")
                .font(.headline)
            TextEditor(text: $viewModel.message)
                .frame(minHeight: 135)
                .scrollContentBackground(.hidden)
                .padding(10)
                .background(.white, in: RoundedRectangle(cornerRadius: 15))
                .overlay(alignment: .topLeading) {
                    if viewModel.message.isEmpty {
                        Text("Dear future me...")
                            .foregroundStyle(LifeGridTheme.secondaryInk.opacity(0.55))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 18)
                            .allowsHitTesting(false)
                    }
                }

            DatePicker(
                "Open on",
                selection: $viewModel.opensAt,
                in: earliestOpeningDate...,
                displayedComponents: .date
            )
            .font(.headline)
            .tint(LifeGridTheme.lavender)

            Button(action: viewModel.sealCapsule) {
                Label("Seal Time Capsule", systemImage: "lock.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .background(LifeGridTheme.lavender, in: Capsule())
        }
        .foregroundStyle(LifeGridTheme.ink)
        .lifeGridCard()
    }

    private var capsulesCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Sealed Capsules")
                .font(.headline)
                .foregroundStyle(LifeGridTheme.ink)

            if viewModel.capsules.isEmpty {
                Text("No capsules yet. Your first message can be short and simple.")
                    .font(.subheadline)
                    .foregroundStyle(LifeGridTheme.secondaryInk)
            } else {
                ForEach(viewModel.capsules) { capsule in
                    HStack(spacing: 13) {
                        Image(systemName: capsule.canOpen() ? "lock.open.fill" : "lock.fill")
                            .foregroundStyle(LifeGridTheme.lavender)
                            .frame(width: 42, height: 42)
                            .background(LifeGridTheme.lavenderSoft, in: Circle())
                        VStack(alignment: .leading, spacing: 3) {
                            Text(capsule.canOpen() ? capsule.message : "A message for your future self")
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(2)
                            Text(capsule.opensAt, format: .dateTime.day().month(.wide).year())
                                .font(.caption)
                                .foregroundStyle(LifeGridTheme.secondaryInk)
                        }
                    }
                }
            }
        }
        .lifeGridCard()
    }

    private var earliestOpeningDate: Date {
        Calendar.current.startOfDay(for: .now).addingTimeInterval(86_400)
    }
}

#Preview {
    TimeCapsuleView(viewModel: TimeCapsuleViewModel())
}
