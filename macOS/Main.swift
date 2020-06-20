import AppKit

final class Main: NSWindow, NSWindowDelegate {
    override var frameAutosaveName: NSWindow.FrameAutosaveName { "Main" }
    private weak var view: View!
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 600, height: 600), styleMask:
            [.borderless, .miniaturizable, .resizable, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        minSize = .init(width: 400, height: 400)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
        let view = View()
        contentView = view
        self.view = view
        
        if !setFrameUsingName(frameAutosaveName) {
            center()
        }
        delegate = self
    }
    
    override func close() {
        NSApp.terminate(nil)
    }
    
    func windowDidMove(_: Notification) {
        saveFrame(usingName: frameAutosaveName)
    }

    func windowDidResize(_: Notification) {
        saveFrame(usingName: frameAutosaveName)
    }
    
    func windowDidBecomeKey(_: Notification) {
        view.pause(false)
    }
    
    func windowDidResignKey(_: Notification) {
        view.pause(true)
    }
}
