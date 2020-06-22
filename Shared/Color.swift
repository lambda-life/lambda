#if os(macOS)
import AppKit

extension NSColor {
    static let background = NSColor.controlBackgroundColor
}
#endif
#if os(iOS)
import UIKit

extension UIColor {
    
}
#endif
