import Foundation

enum MemoryPeriod: String, CaseIterable, Identifiable {
    case year = "Year", month = "Month", week = "Week", day = "Day"
    var id: String { rawValue }
    var calendarComponent: Calendar.Component {
        switch self {
        case .year: .year
        case .month: .month
        case .week: .weekOfYear
        case .day: .day
        }
    }
}
