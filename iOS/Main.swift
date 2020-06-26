import UIKit
import Combine

final class Main: UIViewController {
    private weak var game: View!
    private weak var plus: Circle!
    private weak var base: UIView!
    private weak var accumulated: UILabel!
    private weak var border: UIView?
    private var subs = Set<AnyCancellable>()
    private let player: Player
    private let decimal = NumberFormatter()
    
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
    
    private var count = 0 {
        didSet {
            accumulated.text = decimal.string(from: .init(value: count))!
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
        badge.layer.borderColor = UIColor.separator.cgColor
        badge.layer.borderWidth = 2
        badge.layer.cornerRadius = 13
        base.addSubview(badge)
        
        let generation = UILabel()
        generation.translatesAutoresizingMaskIntoConstraints = false
        generation.textColor = .secondaryLabel
        generation.font = .monospaced(.bold())
        base.addSubview(generation)
        
        let percent = UILabel()
        percent.translatesAutoresizingMaskIntoConstraints = false
        percent.textColor = .secondaryLabel
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
        
        game.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        game.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        base.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        base.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        clock.topAnchor.constraint(equalTo: base.topAnchor, constant: 20).isActive = true
        clock.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 20).isActive = true
        
        seeds.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        seeds.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -20).isActive = true
        
        badge.rightAnchor.constraint(equalTo: percent.rightAnchor, constant: 14).isActive = true
        badge.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        badge.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
        badge.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        generation.leftAnchor.constraint(equalTo: clock.rightAnchor, constant: 3).isActive = true
        generation.centerYAnchor.constraint(equalTo: clock.centerYAnchor).isActive = true
        
        accumulated.rightAnchor.constraint(equalTo: seeds.leftAnchor, constant: -3).isActive = true
        accumulated.centerYAnchor.constraint(equalTo: seeds.centerYAnchor).isActive = true
        
        percent.leftAnchor.constraint(equalTo: badge.leftAnchor, constant: 14).isActive = true
        percent.centerYAnchor.constraint(equalTo: badge.centerYAnchor).isActive = true
        
        plus.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
        plus.topAnchor.constraint(equalTo: base.topAnchor, constant: 80).isActive = true
        
        update(traitCollection)
        
        game.universe.generation.sink { [weak self] in
            guard let self = self else { return }
            self.count = min(self.count + 5, 99)
            generation.text = self.decimal.string(from: .init(value: $0))!
            percent.text = percentage.string(from: .init(value: game.universe.percent(self.player)))!
            self.plus.enabled = self.count > 0
        }.store(in: &subs)
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
        
//        let add = Add(player: player, view: view, count: count)
//        add.close.target = self
//        add.close.action = #selector(cancel)
//        add.button.target = self
//        add.button.action = #selector(accept)
//        contentView!.addSubview(add)
//
//        add.centerXAnchor.constraint(equalTo: contentView!.centerXAnchor).isActive = true
//        add.centerYAnchor.constraint(equalTo: plus.centerYAnchor).isActive = true
//        contentView!.layoutSubtreeIfNeeded()
//        add.open()
//
//        NSAnimationContext.runAnimationGroup ({
//            $0.duration = 0.6
//            $0.allowsImplicitAnimation = true
//            backgroundColor = .underPageBackgroundColor
//            contentView!.layoutSubtreeIfNeeded()
//            add.alphaValue = 1
//        }) {
//            add.tick()
//        }
    }
}
