import UIKit
import Automata

final class Add: UIViewController {
    private weak var main: Main?
    private weak var button: Button!
    private weak var blur: UIVisualEffectView!
    private weak var message: UILabel!
    private weak var barWidth: NSLayoutConstraint!
    private weak var blurLeft: NSLayoutConstraint?
    private weak var blurTop: NSLayoutConstraint?
    private var index = 0
    private let sequence: [Point]
    
    required init?(coder: NSCoder) { nil }
    init(main: Main) {
        self.main = main
        sequence = main.game.universe.sequence(main.count)
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
        message.textColor = .secondaryLabel
        blur.contentView.addSubview(message)
        self.message = message
        
        let progress = UIView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.isUserInteractionEnabled = false
        progress.backgroundColor = .init(white: 1, alpha: 0.1)
        progress.layer.cornerRadius = 10
        progress.clipsToBounds = true
        blur.contentView.addSubview(progress)
        
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.isUserInteractionEnabled = false
        bar.backgroundColor = main!.player.color
        bar.layer.cornerRadius = 8
        progress.addSubview(bar)
        
        let button = Button(text: .key("Add") + " \(main!.count)", background: main!.player.color, foreground: .label)
        button.enabled = false
        button.alpha = 0.4
        button.target = self
        button.action = #selector(accept)
        blur.contentView.addSubview(button)
        self.button = button
        
        close.topAnchor.constraint(equalTo: blur.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        close.leftAnchor.constraint(equalTo: blur.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        
        message.topAnchor.constraint(equalTo: blur.contentView.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        message.centerXAnchor.constraint(equalTo: blur.contentView.centerXAnchor).isActive = true
        
        button.bottomAnchor.constraint(equalTo: blur.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        button.centerXAnchor.constraint(equalTo: blur.contentView.centerXAnchor).isActive = true
        
        progress.centerXAnchor.constraint(equalTo: blur.contentView.centerXAnchor).isActive = true
        progress.centerYAnchor.constraint(equalTo: blur.contentView.centerYAnchor).isActive = true
        progress.widthAnchor.constraint(equalToConstant: 204).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        bar.leftAnchor.constraint(equalTo: progress.leftAnchor, constant: 2).isActive = true
        bar.topAnchor.constraint(equalTo: progress.topAnchor, constant: 2).isActive = true
        bar.bottomAnchor.constraint(equalTo: progress.bottomAnchor, constant: -2).isActive = true
        barWidth = bar.widthAnchor.constraint(equalToConstant: 0)
        barWidth.isActive = true
        
        update(traitCollection)
        tick()
    }
    
    override func willTransition(to: UITraitCollection, with: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: to, with: with)
        update(to)
    }
    
    private func update(_ trait: UITraitCollection) {
        guard let game = main?.game else { return }
        if trait.verticalSizeClass == .compact {
            blurLeft?.constant = game.frame.maxX + 1
            blurTop?.constant = 0
        } else {
            blurLeft?.constant = 0
            blurTop?.constant = game.frame.maxY + 1
        }
    }
    
    private func tick() {
        main!.game.scene!.addChild(Highlight(position: main!.game!.position(sequence[index])))
        UIView.animate(withDuration: 0.05) { [weak self] in
            guard let self = self else { return }
            self.barWidth.constant = (CGFloat(self.index + 1) / .init(self.main!.count)) * 200
        }
        
        guard index < main!.count - 1 else {
            ready()
            return
        }
        index += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.tick()
        }
    }
    
    private func ready() {
        button.enabled = true
        button.alpha = 1
        message.text = .key("Ready")
    }
    
    @objc private func accept() {
        main!.count = 0
        sequence.forEach {
            main!.game!.universe.seed($0, automaton: main!.player)
        }
        close()
    }
    
    @objc private func close() {
        main!.game!.clear()
        dismiss(animated: true) { [weak self] in
            self?.main?.game?.state.cancel()
        }
    }
}
