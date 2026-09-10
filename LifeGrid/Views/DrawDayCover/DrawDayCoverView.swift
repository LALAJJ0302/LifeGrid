import SwiftUI
import PencilKit

struct DrawDayCoverView: View {
    @ObservedObject var viewModel: WeeklyMemoryViewModel
    let date: Date
    @State private var drawing = PKDrawing()
    @State private var mood: MoodSticker?
    @State private var reflection = ""
    @State private var existing: DayCover?
    @State private var canvasSize = CGSize(width: 340, height: 300)
    @State private var loaded = false
    @State private var restoreFailed = false
    @State private var erasing = false
    @State private var ink: Color = .orange
    @State private var saved = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(date.formatted(date: .complete, time: .omitted)).font(.headline)
                if restoreFailed, let data = existing?.artwork?.thumbnailPNGData,
                   let image = UIImage(data: data) {
                    Image(uiImage: image).resizable().scaledToFit().frame(maxHeight: 300)
                    Text("The saved preview is available. Editable strokes could not be restored.")
                } else {
                    HStack {
                        ColorPicker("Ink", selection: $ink, supportsOpacity: false)
                        Toggle("Eraser", isOn: $erasing)
                        Button("Clear") { drawing = PKDrawing() }
                    }
                    PencilCanvasView(drawing: $drawing, ink: UIColor(ink), erasing: erasing)
                        .frame(height: 300)
                        .onGeometryChange(for: CGSize.self) { $0.size } action: { canvasSize = $0 }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                Text("Mood (optional)").font(.headline)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(MoodSticker.allCases) { item in
                            Button {
                                mood = mood == item ? nil : item
                            } label: {
                                Text("\(item.emoji) \(item.displayName)")
                                    .padding(8)
                                    .background(mood == item ? Color.orange.opacity(0.25) : Color.clear)
                            }
                        }
                    }
                }
                Text("Reflection (optional)").font(.headline)
                TextEditor(text: $reflection).frame(height: 110).border(Color.secondary)
                Button(existing == nil ? "Save Day Cover" : "Save Changes") { save() }
                    .buttonStyle(.borderedProminent)
                if saved { Text("Day Cover saved.").foregroundStyle(.secondary) }
            }.padding()
        }
        .navigationTitle("Day Cover")
        .onAppear { restore() }
        .alert(item: $viewModel.alert) { message in
            Alert(title: Text(message.title), message: Text(message.details))
        }
    }

    private func restore() {
        guard !loaded else { return }
        loaded = true
        existing = viewModel.repository.dayCover(for: date)
        mood = existing?.mood
        reflection = existing?.reflection ?? ""
        if let data = existing?.artwork?.editableDrawingData {
            do { drawing = try PKDrawing(data: data) }
            catch {
                restoreFailed = true
                viewModel.alert = AppMessage(title: "This drawing could not be opened",
                    details: "The cover image is still available, but its editable strokes could not be restored. You can still update the mood and reflection.")
            }
        }
    }

    private func save() {
        let artwork = restoreFailed ? existing?.artwork
            : DayCoverArtworkFactory.makeArtwork(from: drawing, canvasSize: canvasSize)
        guard restoreFailed || drawing.strokes.isEmpty || artwork != nil else {
            viewModel.alert = AppMessage(title: "Drawing could not be saved", details: "Keep your drawing and try again.")
            return
        }
        saved = viewModel.saveMemory(for: date, artwork: artwork, mood: mood,
                                     reflection: reflection, existing: existing)
        if saved { existing = viewModel.repository.dayCover(for: date) }
    }
}
