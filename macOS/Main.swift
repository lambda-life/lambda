import AppKit

final class Main: NSWindow, NSWindowDelegate {
    override var frameAutosaveName: NSWindow.FrameAutosaveName { "Main" }
    private weak var view: View!
    private weak var paused: NSView?
    
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
        paused?.removeFromSuperview()
        view.isPaused = false
    }
    
    func windowDidResignKey(_: Notification) {
        view.isPaused = true
        
        let paused = NSView()
        paused.translatesAutoresizingMaskIntoConstraints = false
        paused.wantsLayer = true
        paused.layer!.backgroundColor = NSColor.windowBackgroundColor.withAlphaComponent(0.9).cgColor
        paused.layer!.cornerRadius = 20
        self.paused = paused
        
        let title = Label(.key("Paused"), .bold(2))
        title.textColor = .secondaryLabelColor
        paused.addSubview(title)
        
        view.addSubview(paused)
        
        paused.heightAnchor.constraint(equalToConstant: 40).isActive = true
        paused.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        paused.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paused.rightAnchor.constraint(equalTo: title.rightAnchor, constant: 20).isActive = true
        
        title.centerYAnchor.constraint(equalTo: paused.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: paused.leftAnchor, constant: 20).isActive = true
    }
}
