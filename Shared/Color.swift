#if os(macOS)
import AppKit

extension NSColor {
    static let primaryText = NSColor.labelColor
    static let fadeBackground = NSColor.underPageBackgroundColor
    static let background = NSColor.windowBackgroundColor
    static let shadow = NSColor.controlBackgroundColor
}
#endif
#if os(iOS)
import UIKit

extension UIColor {
    
}
#endif
