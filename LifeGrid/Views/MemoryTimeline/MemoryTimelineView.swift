import SwiftUI

struct MemoryTimelineView: View {
    @ObservedObject var memoryViewModel: WeeklyMemoryViewModel
    @StateObject private var viewModel: MemoryTimelineViewModel

    init(memoryViewModel: WeeklyMemoryViewModel, anchorDate: Date = .now, period: MemoryPeriod = .month) {
        self.memoryViewModel = memoryViewModel
        let model = MemoryTimelineViewModel(browseDayCovers: BrowseDayCoversUseCase(repository: memoryViewModel.repository))
        model.anchorDate = anchorDate
        model.selectedPeriod = period
        _viewModel = StateObject(wrappedValue: model)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Picker("Memory period", selection: $viewModel.selectedPeriod) {
                    ForEach(MemoryPeriod.allCases) { Text($0.rawValue).tag($0) }
                }.pickerStyle(.segmented)
                HStack {
                    Button("Previous", systemImage: "chevron.left") { viewModel.movePeriod(by: -1) }
                    Spacer()
                    Button("Next", systemImage: "chevron.right") { viewModel.movePeriod(by: 1) }
                }
                DatePicker("Date", selection: $viewModel.anchorDate, displayedComponents: .date)
                switch viewModel.selectedPeriod {
                case .year: YearMemoryView(viewModel: viewModel)
                case .month: MonthMemoryView(viewModel: viewModel, memoryViewModel: memoryViewModel)
                case .week: WeekMemoryView(viewModel: viewModel, memoryViewModel: memoryViewModel)
                case .day: DayMemoryView(viewModel: viewModel, memoryViewModel: memoryViewModel)
                }
            }.padding()
        }
        .navigationTitle("Memories")
        .onAppear { viewModel.loadMemories() }
        .onChange(of: viewModel.selectedPeriod) { viewModel.loadMemories() }
        .onChange(of: viewModel.anchorDate) { viewModel.loadMemories() }
        .onChange(of: memoryViewModel.savedCovers) { viewModel.loadMemories() }
        .alert(item: $viewModel.alert) { Alert(title: Text($0.title), message: Text($0.details)) }
    }
}

struct YearMemoryView: View {
    @ObservedObject var viewModel: MemoryTimelineViewModel
    var body: some View {
        let months = viewModel.dates(in: .year, containing: viewModel.anchorDate)
            .filter { viewModel.calendar.component(.day, from: $0) == 1 }
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach(months, id: \.self) { month in
                Button {
                    viewModel.anchorDate = month
                    viewModel.selectedPeriod = .month
                } label: {
                    VStack {
                        Text(month.formatted(.dateTime.month(.wide)))
                        let count = viewModel.dayCovers.filter {
                            viewModel.calendar.isDate($0.day, equalTo: month, toGranularity: .month)
                        }.count
                        Text("\(count) memories").font(.caption)
                    }.frame(maxWidth: .infinity).padding()
                }.buttonStyle(.bordered)
            }
        }
    }
}

struct MonthMemoryView: View {
    @ObservedObject var viewModel: MemoryTimelineViewModel
    @ObservedObject var memoryViewModel: WeeklyMemoryViewModel
    var body: some View {
        let dates = viewModel.dates(in: .month, containing: viewModel.anchorDate)
        let offset = dates.first.map { (viewModel.calendar.component(.weekday, from: $0) - viewModel.calendar.firstWeekday + 7) % 7 } ?? 0
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(0..<7) { index in
                Text(viewModel.calendar.shortWeekdaySymbols[(index + viewModel.calendar.firstWeekday - 1) % 7]).font(.caption2)
            }
            ForEach(0..<offset, id: \.self) { _ in Color.clear.frame(height: 65) }
            ForEach(dates, id: \.self) { date in
                NavigationLink {
                    DrawDayCoverView(viewModel: memoryViewModel, date: date)
                } label: {
                    DayCoverCell(date: date, dayCover: viewModel.dayCover(for: date)).frame(height: 65)
                }.buttonStyle(.plain)
            }
        }
    }
}

struct WeekMemoryView: View {
    @ObservedObject var viewModel: MemoryTimelineViewModel
    @ObservedObject var memoryViewModel: WeeklyMemoryViewModel
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            ForEach(viewModel.dates(in: .week, containing: viewModel.anchorDate), id: \.self) { date in
                NavigationLink {
                    DrawDayCoverView(viewModel: memoryViewModel, date: date)
                } label: {
                    VStack {
                        Text(date.formatted(.dateTime.weekday(.wide)))
                        DayCoverCell(date: date, dayCover: viewModel.dayCover(for: date)).frame(height: 140)
                    }
                }.buttonStyle(.plain)
            }
        }
    }
}

struct DayMemoryView: View {
    @ObservedObject var viewModel: MemoryTimelineViewModel
    @ObservedObject var memoryViewModel: WeeklyMemoryViewModel
    var body: some View {
        let cover = viewModel.dayCover(for: viewModel.anchorDate)
        VStack(spacing: 12) {
            if let data = cover?.artwork?.thumbnailPNGData, let image = UIImage(data: data) {
                Image(uiImage: image).resizable().scaledToFit()
            }
            if let mood = cover?.mood { Text("\(mood.emoji) \(mood.displayName)") }
            if let cover { Text(cover.reflection) }
            NavigationLink(cover == nil ? "Create Day Cover" : "Edit Day Cover") {
                DrawDayCoverView(viewModel: memoryViewModel, date: viewModel.anchorDate)
            }.buttonStyle(.borderedProminent)
        }
    }
}
