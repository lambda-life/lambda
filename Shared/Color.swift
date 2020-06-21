#if os(macOS)
import AppKit

extension NSColor {
    static let primaryText = NSColor.labelColor
    static let secondaryText = NSColor.secondaryLabelColor
    static let tertiaryText = NSColor.tertiaryLabelColor
    static let fadeBackground = NSColor.controlHighlightColor
    static let background = NSColor.windowBackgroundColor
    static let secondaryBackground = NSColor.underPageBackgroundColor
    static let shadow = NSColor.controlBackgroundColor
}
#endif
#if os(iOS)
import UIKit

extension UIColor {
    
}
#endif
