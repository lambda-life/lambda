import UIKit
import Automata

final class Add: UIViewController {
    private weak var player: Player!
    private weak var game: View!
    private weak var button: Button!
    private weak var close: Button!
    private weak var bar: CAShapeLayer!
    private weak var progress: CAShapeLayer!
    private weak var message: UILabel!
    private weak var width: NSLayoutConstraint!
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
