import UIKit
import Combine

final class Main: UIViewController {
    private weak var game: View!
    private weak var plus: Circle!
    private weak var accumulated: UILabel!
    private var subs = Set<AnyCancellable>()
    private let player: Player
    private let decimal = NumberFormatter()
    
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
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.backgroundColor = .separator
        view.addSubview(border)
        
        let clock = UIImageView(image: UIImage(named: "clock")!)
        clock.translatesAutoresizingMaskIntoConstraints = false
        clock.contentMode = .center
        clock.clipsToBounds = true
        clock.tintColor = .secondaryLabel
        view.addSubview(clock)
        
        let seeds = UIImageView(image: UIImage(named: "seeds")!)
        seeds.translatesAutoresizingMaskIntoConstraints = false
        seeds.contentMode = .center
        seeds.clipsToBounds = true
        seeds.tintColor = .secondaryLabel
        view.addSubview(seeds)
        
    }
}
