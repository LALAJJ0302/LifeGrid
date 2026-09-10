import SwiftUI

/// Introduces the 80-year reflection frame and collects the student's age.
struct AgeInputView: View {
    @ObservedObject var viewModel: LifeGridViewModel
    @FocusState private var ageFieldIsFocused: Bool

    var body: some View {
        ZStack {
            LifeGridTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    Spacer(minLength: 34)
                    mark

                    VStack(spacing: 12) {
                        Text("See your time.\nKeep what matters.")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundStyle(LifeGridTheme.ink)
                            .multilineTextAlignment(.center)

                        Text("LifeGrid turns an 80-year reflection frame into 4,160 weeks. It is a gentle perspective, not a prediction.")
                            .font(.body)
                            .foregroundStyle(LifeGridTheme.secondaryInk)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }

                    sampleGrid

                    VStack(alignment: .leading, spacing: 10) {
                        Text("How old are you?")
                            .font(.headline)
                            .foregroundStyle(LifeGridTheme.ink)

                        TextField("For example, 21", text: $viewModel.ageText)
                            .keyboardType(.numberPad)
                            .textContentType(.none)
                            .font(.title3.weight(.semibold))
                            .padding(16)
                            .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 16))
                            .focused($ageFieldIsFocused)
                            .accessibilityLabel("Your age")

                        Text("We only use your age to estimate the weeks shown in your grid.")
                            .font(.caption)
                            .foregroundStyle(LifeGridTheme.secondaryInk)
                    }
                    .lifeGridCard()

                    Button {
                        ageFieldIsFocused = false
                        viewModel.buildLifeGrid()
                    } label: {
                        Label("Create My LifeGrid", systemImage: "sparkles")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.white)
                    .background(LifeGridTheme.peach, in: Capsule())
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 36)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .alert(item: $viewModel.alert) { message in
            Alert(title: Text(message.title), message: Text(message.details), dismissButton: .default(Text("Try Again")))
        }
    }

    private var mark: some View {
        HStack(spacing: 10) {
            Image(systemName: "circle.grid.3x3.fill")
                .foregroundStyle(LifeGridTheme.peach)
            Text("LifeGrid")
                .font(.title2.weight(.bold))
                .foregroundStyle(LifeGridTheme.ink)
        }
    }

    private var sampleGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(11), spacing: 5), count: 16), spacing: 5) {
            ForEach(0..<64, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(index < 18 ? LifeGridTheme.peach : LifeGridTheme.lavenderSoft)
                    .frame(width: 11, height: 11)
            }
        }
        .padding(18)
        .background(LifeGridTheme.surface, in: RoundedRectangle(cornerRadius: 22))
        .accessibilityHidden(true)
    }
}

#Preview {
    AgeInputView(viewModel: LifeGridViewModel())
}
