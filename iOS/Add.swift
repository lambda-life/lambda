import UIKit
import Automata

final class Add: UIViewController {
    private weak var game: View?
    private weak var player: Player!
    private weak var button: Button!
    private weak var blur: UIVisualEffectView!
    private weak var bar: CAShapeLayer!
    private weak var progress: CAShapeLayer!
    private weak var message: UILabel!
    private weak var blurLeft: NSLayoutConstraint?
    private weak var blurTop: NSLayoutConstraint?
    private var index = 0
    private let count: Int
    private let sequence: [Point]
    
    required init?(coder: NSCoder) { nil }
    init(player: Player, game: View, count: Int) {
        self.player = player
        self.game = game
        self.count = count
        sequence = game.universe.sequence(count)
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blur.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blur)
        self.blur = blur
        
        blur.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        blurLeft = blur.leftAnchor.constraint(equalTo: view.leftAnchor)
        blurLeft!.isActive = true
        blurTop = blur.topAnchor.constraint(equalTo: view.topAnchor)
        blurTop!.isActive = true
        
        let close = Button(icon: "x", color: .label)
        close.target = self
        close.action = #selector(self.close)
        blur.contentView.addSubview(close)
        
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.text = .key("Loading")
        message.font = .bold(-2)
        message.textColor = .tertiaryLabel
        blur.contentView.addSubview(message)
        self.message = message
        
        let progress = CAShapeLayer()
        progress.lineWidth = 0
        progress.fillColor = .init(genericGrayGamma2_2Gray: 0, alpha: 0.1)
        progress.path = .init(roundedRect: .init(x: 50, y: 15, width: 200, height: 20), cornerWidth: 10, cornerHeight: 10, transform: nil)
        blur.contentView.layer.addSublayer(progress)
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
        
        let button = Button(text: .key("Add") + " \(count)", background: player.color, foreground: .label)
        button.enabled = false
        button.alpha = 0.4
        blur.contentView.addSubview(button)
        self.button = button
        
        close.topAnchor.constraint(equalTo: blur.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        close.leftAnchor.constraint(equalTo: blur.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
        message.topAnchor.constraint(equalTo: blur.contentView.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        message.centerXAnchor.constraint(equalTo: blur.contentView.centerXAnchor).isActive = true
        
        button.bottomAnchor.constraint(equalTo: blur.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        button.centerXAnchor.constraint(equalTo: blur.contentView.centerXAnchor).isActive = true
        
        update(traitCollection)
    }
    
    private func update(_ trait: UITraitCollection) {
        guard let game = self.game else { return }
        if trait.verticalSizeClass == .compact {
            
        } else {
            blurLeft?.constant = 0
            blurTop?.constant = game.frame.maxY + 1
        }
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
