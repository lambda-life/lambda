#if os(macOS)
import AppKit

extension NSColor {
    static let background = NSColor.controlBackgroundColor
    static let highlight = NSColor.labelColor
}
#endif
#if os(iOS)
import UIKit

extension UIColor {
    
}
#endif
