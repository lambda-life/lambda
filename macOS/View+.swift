import AppKit

extension View {
    override func mouseDown(with: NSEvent) {
        var point = window!.contentView!.convert(with.locationInWindow, from: nil)
        point.x -= window!.contentView!.frame.midX
        point.y -= window!.contentView!.frame.midY
        state.touch(point)
    }
}
