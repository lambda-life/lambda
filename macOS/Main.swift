import AppKit

final class Main: NSWindow, NSWindowDelegate {
    override var frameAutosaveName: NSWindow.FrameAutosaveName { "Main" }
    private weak var view: View!
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 800, height: 800), styleMask:
            [.borderless, .miniaturizable, .resizable, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        minSize = .init(width: 340, height: 540)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
        let borderTop = NSView()
        borderTop.translatesAutoresizingMaskIntoConstraints = false
        borderTop.wantsLayer = true
        borderTop.layer!.backgroundColor = NSColor.controlDarkShadowColor.cgColor
        contentView!.addSubview(borderTop)
        
        let view = View()
        contentView!.addSubview(view)
        self.view = view
        
        let borderBottom = NSView()
        borderBottom.translatesAutoresizingMaskIntoConstraints = false
        borderBottom.wantsLayer = true
        borderBottom.layer!.backgroundColor = NSColor.controlDarkShadowColor.cgColor
        contentView!.addSubview(borderBottom)
        
        let add = Circle(icon: "plus")
        add.target = self
        add.action = #selector(touchAdd)
        contentView!.addSubview(add)
        view.add = add
        
        borderTop.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 40).isActive = true
        borderTop.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        borderTop.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        borderTop.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: borderTop.bottomAnchor).isActive = true
        
        borderBottom.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        borderBottom.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        borderBottom.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        borderBottom.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        add.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        add.topAnchor.constraint(equalTo: borderBottom.bottomAnchor, constant: 40).isActive = true
        
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
