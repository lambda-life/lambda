import AppKit
import Combine

final class Main: NSWindow, NSWindowDelegate {
    override var frameAutosaveName: NSWindow.FrameAutosaveName { "Main" }
    private weak var view: View!
    private weak var plus: Circle!
    private var subs = Set<AnyCancellable>()
    private let player = Player(color: .systemBlue)
    
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
        
        let decimal = NumberFormatter()
        decimal.numberStyle = .decimal
        
        let percentage = NumberFormatter()
        percentage.numberStyle = .percent
        
        let view = View()
        view.universe.random(100, automaton: player)
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
        
        let square = NSView()
        square.translatesAutoresizingMaskIntoConstraints = false
        square.wantsLayer = true
        square.layer!.borderColor = NSColor.underPageBackgroundColor.cgColor
        square.layer!.borderWidth = 1
        square.layer!.backgroundColor = player.color.cgColor
        contentView!.addSubview(square)
        
        let generation = Label("", .monospaced(.bold()))
        generation.textColor = .secondaryLabelColor
        contentView!.addSubview(generation)
        
        let percent = Label("", .monospaced(.bold()))
        percent.textColor = .secondaryLabelColor
        contentView!.addSubview(percent)
        
        let plus = Circle(icon: "plus")
        plus.target = self
        plus.action = #selector(adding)
        contentView!.addSubview(plus)
        self.plus = plus
        
        view.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        
        border.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        clock.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 20).isActive = true
        clock.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 20).isActive = true
        
        square.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        square.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        square.widthAnchor.constraint(equalToConstant: 14).isActive = true
        square.heightAnchor.constraint(equalTo: square.widthAnchor).isActive = true
        
        generation.leftAnchor.constraint(equalTo: clock.rightAnchor, constant: 3).isActive = true
        generation.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        
        percent.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        percent.leftAnchor.constraint(equalTo: square.rightAnchor, constant: 3).isActive = true
        
        plus.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        plus.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 75).isActive = true
        
        if !setFrameUsingName(frameAutosaveName) {
            center()
        }
        delegate = self
        
        view.universe.generation.sink { [weak self] in
            guard let self = self else { return }
            generation.stringValue = decimal.string(from: .init(value: $0))!
            percent.stringValue = percentage.string(from: .init(value: view.universe.percent(self.player)))!
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
    
    @objc private func adding() {
        view.state.add()
        plus.selected = true
        
        let add = Add(player: player, view: view)
        add.close.target = self
        add.close.action = #selector(cancel)
        add.button.target = self
        add.button.action = #selector(accept)
        contentView!.addSubview(add)
        
        add.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        add.centerYAnchor.constraint(equalTo: plus.centerYAnchor).isActive = true
        contentView!.layoutSubtreeIfNeeded()
        add.open()
        
        NSAnimationContext.runAnimationGroup ({
            $0.duration = 0.6
            $0.allowsImplicitAnimation = true
            backgroundColor = .underPageBackgroundColor
            contentView!.layoutSubtreeIfNeeded()
            add.alphaValue = 1
        }) {
            add.tick()
        }
    }
    
    @objc private func cancel(_ close: Button) {
        let add = close.superview as! Add
        add.cancel()
        
        NSAnimationContext.runAnimationGroup({
            $0.duration = 0.3
            $0.allowsImplicitAnimation = true
            backgroundColor = .windowBackgroundColor
            contentView!.layoutSubtreeIfNeeded()
        }) { [weak self] in
            add.removeFromSuperview()
            self?.plus.selected = false
            self?.view.state.cancel()
        }
    }
    
    @objc private func accept(_ accept: Button) {
        accept.enabled = false
        let add = accept.superview as! Add
        add.sequence.forEach {
            view.universe.seed($0, automaton: player)
        }
        cancel(accept)
    }
}
