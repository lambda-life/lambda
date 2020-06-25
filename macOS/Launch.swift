import AppKit

final class Launch: NSWindow, NSWindowDelegate {
    override var frameAutosaveName: NSWindow.FrameAutosaveName { "Launch" }
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 700, height: 500), styleMask:
            [.borderless, .miniaturizable, .resizable, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        minSize = .init(width: 700, height: 500)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
        let logo = NSImageView(image: NSImage(named: "logo")!)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.imageScaling = .scaleNone
        contentView!.addSubview(logo)
        
        let title = Label(.key("Title"), .bold(20))
        title.textColor = .systemIndigo
        contentView!.addSubview(title)
        
        let instructions = Label(.key("Instructions"), .medium())
        instructions.textColor = .tertiaryLabelColor
        instructions.alignment = .center
        contentView!.addSubview(instructions)
        
        let blue = Item(color: .systemBlue)
        blue.target = self
        blue.action = #selector(select(item:))
        contentView!.addSubview(blue)
        
        let orange = Item(color: .systemOrange)
        orange.target = self
        orange.action = #selector(select(item:))
        contentView!.addSubview(orange)
        
        let pink = Item(color: .systemPink)
        pink.target = self
        pink.action = #selector(select(item:))
        contentView!.addSubview(pink)
        
        let indigo = Item(color: .systemIndigo)
        indigo.target = self
        indigo.action = #selector(select(item:))
        contentView!.addSubview(indigo)
        
        let teal = Item(color: .systemTeal)
        teal.target = self
        teal.action = #selector(select(item:))
        contentView!.addSubview(teal)
        
        let create = Button(text: .key("Create"), background: .systemIndigo, foreground: .controlTextColor)
        create.target = self
        create.action = #selector(self.create)
        contentView!.addSubview(create)
        
        logo.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 90).isActive = true
        
        title.topAnchor.constraint(equalTo: logo.bottomAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        
        instructions.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2).isActive = true
        instructions.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        
        blue.centerYAnchor.constraint(equalTo: instructions.bottomAnchor, constant: 100).isActive = true
        blue.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        
        orange.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        orange.rightAnchor.constraint(equalTo: blue.leftAnchor, constant: -20).isActive = true
        
        pink.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        pink.leftAnchor.constraint(equalTo: blue.rightAnchor, constant: 20).isActive = true
        
        indigo.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        indigo.rightAnchor.constraint(equalTo: orange.leftAnchor, constant: -20).isActive = true
        
        teal.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        teal.leftAnchor.constraint(equalTo: pink.rightAnchor, constant: 20).isActive = true
        
        create.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        create.topAnchor.constraint(equalTo: blue.centerYAnchor, constant: 80).isActive = true
        
        select(item: blue)
        
        if !setFrameUsingName(frameAutosaveName) {
            center()
        }
        delegate = self
    }
    
    override func close() {
        super.close()
        NSApp.close()
    }
    
    func windowDidMove(_: Notification) {
        saveFrame(usingName: frameAutosaveName)
    }

    func windowDidResize(_: Notification) {
        saveFrame(usingName: frameAutosaveName)
    }
    
    @objc private func select(item: Item) {
        contentView!.subviews.compactMap { $0 as? Item }.forEach {
            $0.enabled = $0 != item
        }
    }
    
    @objc private func create() {
        let automaton = Main(color: contentView!.subviews.compactMap { $0 as? Item }.first { !$0.enabled }!.color)
        automaton.center()
        automaton.makeKeyAndOrderFront(nil)
    }
}

private final class Item: Control {
    override var enabled: Bool {
        didSet {
            layer!.backgroundColor = enabled ? .clear : NSColor.separatorColor.cgColor
            layer!.cornerRadius = enabled ? 22 : 37
            width.constant = enabled ? 44 : 74
            circle.layer!.cornerRadius = enabled ? 17 : 32
        }
    }
    
    let color: NSColor
    private weak var circle: NSView!
    private weak var width: NSLayoutConstraint!
    
    required init?(coder: NSCoder) { nil }
    init(color: NSColor) {
        self.color = color
        super.init()
        wantsLayer = true
        layer!.cornerRadius = 35
        
        let circle = NSView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.wantsLayer = true
        circle.layer!.backgroundColor = color.cgColor
        circle.layer!.borderColor = NSColor.underPageBackgroundColor.cgColor
        addSubview(circle)
        self.circle = circle
        
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        width = widthAnchor.constraint(equalToConstant: 20)
        width.isActive = true
        
        circle.widthAnchor.constraint(equalTo: widthAnchor, constant: -10).isActive = true
        circle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
    }
    
    override func hoverOn() {
        alphaValue = 0.3
    }
    
    override func hoverOff() {
        alphaValue = 1
    }
}
