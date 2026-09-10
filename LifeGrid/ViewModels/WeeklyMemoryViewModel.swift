import Foundation
import Combine

@MainActor
final class WeeklyMemoryViewModel: ObservableObject {
    @Published private(set) var savedCovers: [DayCover] = []
    @Published var alert: AppMessage?
    let repository: any DayCoverRepository

    init(repository: (any DayCoverRepository)? = nil) {
        self.repository = repository ?? InMemoryDayCoverRepository()
        reload()
    }

    func reload() { savedCovers = repository.allDayCovers() }

    @discardableResult
    func saveMemory(for date: Date, artwork: DayCoverArtwork?, mood: MoodSticker?,
                    reflection: String, existing: DayCover? = nil) -> Bool {
        var cover = existing ?? DayCover(day: date)
        cover.artwork = artwork
        cover.mood = mood
        cover.reflection = reflection
        do {
            if existing != nil {
                try UpdateDayCoverUseCase(repository: repository).execute(dayCover: cover)
            } else {
                try CreateDayCoverUseCase(repository: repository).execute(dayCover: cover)
            }
            reload()
            return true
        } catch let error as CreateDayCoverError {
            alert = error.appMessage
        } catch {
            alert = AppMessage(title: "We couldn't save this memory", details: "Keep your work and try again.")
        }
        return false
    }
}
