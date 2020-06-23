import AppKit

final class Add: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = NSColor.underPageBackgroundColor.cgColor
        layer!.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer!.cornerRadius = 12
    }
}
