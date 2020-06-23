import AppKit
import Combine

final class Main: NSWindow, NSWindowDelegate {
    override var frameAutosaveName: NSWindow.FrameAutosaveName { "Main" }
    private weak var view: View!
    private weak var add: Circle!
    private var subs = Set<AnyCancellable>()
    
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
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let view = View()
        contentView!.addSubview(view)
        self.view = view
        
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.backgroundColor = NSColor.controlDarkShadowColor.cgColor
        contentView!.addSubview(border)
        
        let clock = NSImageView(image: NSImage(named: "clock")!)
        clock.translatesAutoresizingMaskIntoConstraints = false
        clock.imageScaling = .scaleNone
        clock.contentTintColor = .secondaryLabelColor
        contentView!.addSubview(clock)
        
        let generation = Label("", .monospaced(.bold()))
        generation.textColor = .secondaryLabelColor
        contentView!.addSubview(generation)
        
        let add = Circle(icon: "plus")
        add.target = self
        add.action = #selector(touchAdd)
        contentView!.addSubview(add)
        self.add = add
        
        view.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        
        border.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        clock.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 20).isActive = true
        clock.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 20).isActive = true
        
        generation.leftAnchor.constraint(equalTo: clock.rightAnchor, constant: 3).isActive = true
        generation.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        
        add.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        add.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 40).isActive = true
        
        if !setFrameUsingName(frameAutosaveName) {
            center()
        }
        delegate = self
        
        view.universe.generation.sink {
            generation.stringValue = formatter.string(from: .init(value: $0))!
        }.store(in: &subs)
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
        add.selected = true
    }
}
