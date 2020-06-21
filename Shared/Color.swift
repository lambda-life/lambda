#if os(macOS)
import AppKit

extension NSColor {
    static let primaryText = NSColor.labelColor
    static let fadeBackground = NSColor.controlHighlightColor
    static let background = NSColor.windowBackgroundColor
}
#endif
#if os(iOS)
import UIKit

extension UIColor {
    
}
#endif
