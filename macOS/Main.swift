import AppKit

final class Main: NSWindow, NSWindowDelegate {
    override var frameAutosaveName: NSWindow.FrameAutosaveName { "Main" }
    private weak var view: View!
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 800, height: 800), styleMask:
            [.borderless, .miniaturizable, .resizable, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        minSize = .init(width: 300, height: 480)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
        let view = View()
        contentView!.addSubview(view)
        self.view = view
        
        let add = Circle(icon: "plus")
        add.target = self
        add.action = #selector(touchAdd)
        contentView!.addSubview(add)
        view.add = add
        
        view.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: contentView!.centerYAnchor).isActive = true
        
        add.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        add.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 30).isActive = true
        
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
    
    @objc private func touchAdd() {
        view.state.add()
    }
}
