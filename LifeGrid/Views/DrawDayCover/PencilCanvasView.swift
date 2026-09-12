import SwiftUI
import PencilKit
import Combine

@MainActor
final class PencilCanvasController: ObservableObject {
    @Published private(set) var canUndo = false
    @Published private(set) var canRedo = false

    private weak var canvasView: PKCanvasView?

    fileprivate func connect(to canvasView: PKCanvasView) {
        self.canvasView = canvasView
        refreshAvailability()
    }

    fileprivate func refreshAvailability() {
        canUndo = canvasView?.undoManager?.canUndo ?? false
        canRedo = canvasView?.undoManager?.canRedo ?? false
    }

    func undo() {
        canvasView?.undoManager?.undo()
        refreshAvailability()
    }

    func redo() {
        canvasView?.undoManager?.redo()
        refreshAvailability()
    }

    func resetUndoHistory() {
        canvasView?.undoManager?.removeAllActions()
        refreshAvailability()
    }
}

struct PencilCanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    let controller: PencilCanvasController
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
        controller.connect(to: canvas)
        return canvas
    }
    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        context.coordinator.parent = self
        controller.connect(to: canvas)
        canvas.tool = erasing
            ? PKEraserTool(.vector)
            : PKInkingTool(.pen, color: ink, width: brushWidth)
        if canvas.drawing.dataRepresentation() != drawing.dataRepresentation() {
            canvas.drawing = drawing
        }
        controller.refreshAvailability()
    }
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilCanvasView
        init(parent: PencilCanvasView) { self.parent = parent }
        func canvasViewDrawingDidChange(_ canvas: PKCanvasView) {
            parent.drawing = canvas.drawing
            parent.controller.refreshAvailability()
        }
    }
}
