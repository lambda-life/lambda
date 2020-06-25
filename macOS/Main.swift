import AppKit
import Combine

final class Main: NSWindow {
    private weak var view: View!
    private weak var plus: Circle!
    private weak var accumulated: Label!
    private var subs = Set<AnyCancellable>()
    private let player: Player
    private let decimal = NumberFormatter()
    
    private var count = 0 {
        didSet {
            accumulated.stringValue = decimal.string(from: .init(value: count))!
        }
    }
    
    init(color: NSColor) {
        player = .init(color: color)
        super.init(contentRect: .init(x: 0, y: 0, width: 340, height: 540), styleMask:
            [.borderless, .miniaturizable, .closable, .titled, .unifiedTitleAndToolbar, .fullSizeContentView],
                   backing: .buffered, defer: false)
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        toolbar = .init()
        toolbar!.showsBaselineSeparator = false
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        
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
        
        let seeds = NSImageView(image: NSImage(named: "seeds")!)
        seeds.translatesAutoresizingMaskIntoConstraints = false
        seeds.imageScaling = .scaleNone
        seeds.contentTintColor = .secondaryLabelColor
        contentView!.addSubview(seeds)
        
        let badge = NSView()
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.wantsLayer = true
        badge.layer!.borderColor = NSColor.separatorColor.cgColor
        badge.layer!.borderWidth = 2
        badge.layer!.backgroundColor = player.color.cgColor
        badge.layer!.cornerRadius = 13
        contentView!.addSubview(badge)
        
        let generation = Label("", .monospaced(.bold()))
        generation.textColor = .secondaryLabelColor
        contentView!.addSubview(generation)
        
        let percent = Label("", .monospaced(.bold()))
        percent.textColor = .controlTextColor
        contentView!.addSubview(percent)
        
        let plus = Circle(icon: "plus")
        plus.target = self
        plus.action = #selector(adding)
        plus.enabled = false
        contentView!.addSubview(plus)
        self.plus = plus
        
        let accumulated = Label("", .monospaced(.bold()))
        accumulated.textColor = .secondaryLabelColor
        contentView!.addSubview(accumulated)
        self.accumulated = accumulated
        
        view.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        
        border.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        border.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        clock.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 20).isActive = true
        clock.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 20).isActive = true
        
        seeds.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        seeds.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -20).isActive = true
        
        badge.rightAnchor.constraint(equalTo: percent.rightAnchor, constant: 14).isActive = true
        badge.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        badge.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        badge.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        generation.leftAnchor.constraint(equalTo: clock.rightAnchor, constant: 3).isActive = true
        generation.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        
        accumulated.rightAnchor.constraint(equalTo: seeds.leftAnchor, constant: -3).isActive = true
        accumulated.centerYAnchor.constraint(equalTo: seeds.centerYAnchor).isActive = true
        
        percent.leftAnchor.constraint(equalTo: badge.leftAnchor, constant: 14).isActive = true
        percent.centerYAnchor.constraint(equalTo: badge.centerYAnchor).isActive = true
        
        plus.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
        plus.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 80).isActive = true
        
        view.universe.generation.sink { [weak self] in
            guard let self = self else { return }
            self.count = min(self.count + 5, 99)
            generation.stringValue = self.decimal.string(from: .init(value: $0))!
            percent.stringValue = percentage.string(from: .init(value: view.universe.percent(self.player)))!
            self.plus.enabled = self.count > 0
        }.store(in: &subs)
    }
    
    override func close() {
        super.close()
        NSApp.launch()
    }
    
    @objc private func adding() {
        view.state.add()
        plus.enabled = false
        
        let add = Add(player: player, view: view, count: count)
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
            self?.view.state.cancel()
        }
    }
    
    @objc private func accept(_ accept: Button) {
        accept.enabled = false
        count = 0
        let add = accept.superview as! Add
        add.sequence.forEach {
            view.universe.seed($0, automaton: player)
        }
        cancel(accept)
    }
}
