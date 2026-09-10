import SwiftUI

struct DayCoverCell: View {
    let date: Date
    let dayCover: DayCover?
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12).fill(LifeGridTheme.surface)
                if let data = dayCover?.artwork?.thumbnailPNGData, let image = UIImage(data: data) {
                    Image(uiImage: image).resizable().scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height).clipped()
                } else {
                    Text(dayCover?.mood?.emoji ?? (dayCover == nil ? "+" : "📝"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                Text(date.formatted(.dateTime.day())).font(.caption.bold())
                    .padding(4).background(.white.opacity(0.85))
            }.clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .accessibilityLabel("\(date.formatted(date: .complete, time: .omitted)), \(dayCover == nil ? "Create cover" : "Open cover")")
    }
}
