import UIKit
import Combine

final class Main: UIViewController {
    private(set) weak var game: View!
    private weak var plus: Circle!
    private weak var base: UIView!
    private weak var accumulated: UILabel!
    private weak var border: UIView?
    private var subs = Set<AnyCancellable>()
    let player: Player
    private let decimal = NumberFormatter()
    
    var count = 0 {
        didSet {
            UIView.transition(with: accumulated, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
                guard let self = self else { return }
                self.accumulated.text = self.decimal.string(from: .init(value: self.count))!
            })
        }
    }
    
    private weak var gameRight: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            gameRight!.isActive = true
        }
    }
    
    private weak var gameBottom: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            gameBottom!.isActive = true
        }
    }
    
    private weak var baseTop: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            baseTop!.isActive = true
        }
    }
    
    private weak var baseLeft: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            baseLeft!.isActive = true
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(color: UIColor) {
        player = .init(color: color)
        super.init(nibName: nil, bundle: nil)
        decimal.numberStyle = .decimal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let percentage = NumberFormatter()
        percentage.numberStyle = .percent
        
        let game = View()
        game.universe.random(100, automaton: player)
        view.addSubview(game)
        self.game = game
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(base)
        self.base = base
        
        let clock = UIImageView(image: UIImage(named: "clock")!)
        clock.translatesAutoresizingMaskIntoConstraints = false
        clock.contentMode = .center
        clock.clipsToBounds = true
        clock.tintColor = .secondaryLabel
        base.addSubview(clock)
        
        let seeds = UIImageView(image: UIImage(named: "seeds")!)
        seeds.translatesAutoresizingMaskIntoConstraints = false
        seeds.contentMode = .center
        seeds.clipsToBounds = true
        seeds.tintColor = .secondaryLabel
        base.addSubview(seeds)
        
        let badge = UIView()
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.isUserInteractionEnabled = false
        badge.backgroundColor = player.color
        badge.layer.cornerRadius = 6
        base.addSubview(badge)
        
        let generation = UILabel()
        generation.translatesAutoresizingMaskIntoConstraints = false
        generation.textColor = .secondaryLabel
        generation.font = .monospaced(.bold())
        base.addSubview(generation)
        
        let percent = UILabel()
        percent.translatesAutoresizingMaskIntoConstraints = false
        percent.font = .monospaced(.bold())
        base.addSubview(percent)
        
        let plus = Circle(icon: "plus")
        plus.target = self
        plus.action = #selector(adding)
        plus.enabled = false
        base.addSubview(plus)
        self.plus = plus
        
        let accumulated = UILabel()
        accumulated.translatesAutoresizingMaskIntoConstraints = false
        accumulated.textColor = .secondaryLabel
        accumulated.font = .monospaced(.bold())
        base.addSubview(accumulated)
        self.accumulated = accumulated
        
        let close = Button(text: .key("Close"), background: .systemPink, foreground: .label)
        close.target = self
        close.action = #selector(self.close)
        base.addSubview(close)
        
        game.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        game.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        base.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        base.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        clock.topAnchor.constraint(equalTo: base.topAnchor, constant: 30).isActive = true
        clock.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 30).isActive = true
        
        seeds.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        seeds.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -30).isActive = true
        
        badge.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        badge.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
        badge.heightAnchor.constraint(equalToConstant: 34).isActive = true
        badge.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        generation.leftAnchor.constraint(equalTo: clock.rightAnchor, constant: 3).isActive = true
        generation.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        
        accumulated.rightAnchor.constraint(equalTo: seeds.leftAnchor, constant: -3).isActive = true
        accumulated.centerYAnchor.constraint(equalTo: seeds.centerYAnchor).isActive = true
        
        percent.centerXAnchor.constraint(equalTo: badge.centerXAnchor).isActive = true
        percent.centerYAnchor.constraint(equalTo: badge.centerYAnchor).isActive = true
        
        plus.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
        plus.centerYAnchor.constraint(equalTo: base.centerYAnchor).isActive = true
        
        close.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
        close.bottomAnchor.constraint(equalTo: base.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        
        update(traitCollection)
        
        game.universe.generation.sink { [weak self] new in
            guard let self = self else { return }
            self.count = min(self.count + 5, 99)
            
            UIView.transition(with: generation, duration: 0.3, options: .transitionCrossDissolve, animations: {
                generation.text = self.decimal.string(from: .init(value: new))!
            })
            
            UIView.transition(with: percent, duration: 0.3, options: .transitionCrossDissolve, animations: {
                percent.text = percentage.string(from: .init(value: game.universe.percent(self.player)))!
            })
            
            self.plus.enabled = self.count > 0
        }.store(in: &subs)
    }
    
    override func willTransition(to: UITraitCollection, with: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: to, with: with)
        update(to)
    }
    
    private func update(_ trait: UITraitCollection) {
        self.border?.removeFromSuperview()
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.backgroundColor = .separator
        view.addSubview(border)
        self.border = border
        
        if trait.verticalSizeClass == .compact {
            border.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            border.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            border.leftAnchor.constraint(equalTo: game.rightAnchor).isActive = true
            border.widthAnchor.constraint(equalToConstant: 1).isActive = true
            
            gameRight = game.rightAnchor.constraint(equalTo: view.leftAnchor, constant: 360)
            gameBottom = game.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            baseLeft = base.leftAnchor.constraint(equalTo: border.rightAnchor)
            baseTop = base.topAnchor.constraint(equalTo: view.topAnchor)
        } else {
            border.topAnchor.constraint(equalTo: game.bottomAnchor).isActive = true
            border.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            border.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            border.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            gameRight = game.rightAnchor.constraint(equalTo: view.rightAnchor)
            gameBottom = game.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 360)
            
            baseLeft = base.leftAnchor.constraint(equalTo: view.leftAnchor)
            baseTop = base.topAnchor.constraint(equalTo: border.bottomAnchor)
        }
    }
    
    @objc private func adding() {
        game.state.add()
        plus.enabled = false
        present(Add(main: self), animated: true)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
