import AppKit
import Automata

final class Add: NSView {
    private(set) weak var close: Button!
    private(set) weak var bar: CAShapeLayer!
    private(set) weak var progress: CAShapeLayer!
    private(set) weak var button: Button!
    let sequence: [Point]
    private weak var message: Label!
    private weak var view: View!
    private weak var width: NSLayoutConstraint!
    private var index = 0
    private let count = 10
    
    required init?(coder: NSCoder) { nil }
    init(player: Player, view: View) {
        sequence = view.universe.sequence(count)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = NSColor.windowFrameColor.cgColor
        layer!.cornerRadius = 12
        layer!.borderColor = NSColor.windowBackgroundColor.cgColor
        layer!.borderWidth = 2
        alphaValue = 0
        self.view = view
        
        let close = Button(icon: "x", color: .controlTextColor)
        self.close = close
        addSubview(close)
        
        let message = Label(.key("Loading"), .bold())
        addSubview(message)
        self.message = message
        
        let progress = CAShapeLayer()
        progress.lineWidth = 0
        progress.fillColor = .init(gray: 0, alpha: 0.1)
        progress.path = .init(roundedRect: .init(x: 50, y: 15, width: 200, height: 20), cornerWidth: 10, cornerHeight: 10, transform: nil)
        layer!.addSublayer(progress)
        self.progress = progress
        
        let bar = CAShapeLayer()
        bar.lineWidth = 20
        bar.strokeColor = player.color.cgColor
        bar.path = {
            $0.move(to: .init(x: 50, y: 25))
            $0.addLine(to: .init(x: 250, y: 25))
            return $0
        } (CGMutablePath())
        bar.strokeEnd = 0
        bar.mask = {
            $0.path = .init(roundedRect: .init(x: 52, y: 17, width: 196, height: 16), cornerWidth: 8, cornerHeight: 8, transform: nil)
            return $0
        } (CAShapeLayer())
        progress.addSublayer(bar)
        self.bar = bar
        
        let button = Button(text: .key("Add"), background: player.color, foreground: .labelColor)
        button.enabled = false
        button.alphaValue = 0.4
        addSubview(button)
        self.button = button
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        width = widthAnchor.constraint(equalToConstant: 0)
        width.isActive = true
        
        close.topAnchor.constraint(equalTo: topAnchor).isActive = true
        close.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        message.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        message.leftAnchor.constraint(equalTo: leftAnchor, constant: 60).isActive = true
        
        button.centerYAnchor.constraint(equalTo: message.centerYAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor, constant: -60).isActive = true
    }
    
    func open() {
        width.constant = 300
    }
    
    func cancel() {
        view.scene!.children.compactMap { $0 as? Highlight }.forEach { $0.removeFromParent() }
        width.constant = 0
    }
    
    func tick() {
        view.scene!.addChild(Highlight(position: view.position(sequence[index])))
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.2
        animation.fromValue = bar.strokeEnd
        animation.toValue = CGFloat(index + 1) / CGFloat(count)
        bar.strokeEnd = animation.toValue as! CGFloat
        bar.add(animation, forKey: "strokeEnd")
        
        guard index < count - 1 else {
            ready()
            return
        }
        index += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration) { [weak self] in
            self?.tick()
        }
    }
    
    private func ready() {
        button.enabled = true
        button.alphaValue = 1
        message.stringValue = .key("Ready")
        progress.opacity = 0.5
    }
}
