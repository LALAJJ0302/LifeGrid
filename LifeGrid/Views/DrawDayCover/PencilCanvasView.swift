import SwiftUI
import PencilKit

struct PencilCanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    var ink: UIColor = .systemOrange
    var brushWidth: CGFloat = 6
    var erasing = false

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.delegate = context.coordinator
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .white
        canvas.isScrollEnabled = false
        canvas.drawing = drawing
        return canvas
    }
    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        context.coordinator.parent = self
        canvas.tool = erasing
            ? PKEraserTool(.vector)
            : PKInkingTool(.pen, color: ink, width: brushWidth)
        if canvas.drawing.dataRepresentation() != drawing.dataRepresentation() {
            canvas.drawing = drawing
        }
    }
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilCanvasView
        init(parent: PencilCanvasView) { self.parent = parent }
        func canvasViewDrawingDidChange(_ canvas: PKCanvasView) {
            parent.drawing = canvas.drawing
        }
    }
}
