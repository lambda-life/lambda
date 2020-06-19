import SpriteKit
import Automata
import Combine

final class View: SKView, SKSceneDelegate {
    var times = Times()
    private var cells = [[Cell]]()
    private var subs = Set<AnyCancellable>()
    private let universe = Universe(size: 10)
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        
        let scene = SKScene()
        scene.delegate = self
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .controlBackgroundColor
        scene.physicsWorld.gravity = .zero
        
        let camera = SKCameraNode()
        scene.camera = camera
        presentScene(scene)
        
        let delta = (CGFloat(universe.grid.size) / 2) * 20
        cells = (0 ..< universe.grid.size).map { x in
            (0 ..< universe.grid.size).map { y in
                let cell = Cell(radius: 10)
                cell.position = .init(x: .init(x * 20) - delta, y: .init(y * 20) - delta)
                scene.addChild(cell)
                return cell
            }
        }
        
        universe.born.sink { [weak self] in
            self?.cells[$0.x][$0.y].alive = true
        }.store(in: &subs)
        
        universe.die.sink { [weak self] in
            self?.cells[$0.x][$0.y].alive = false
        }.store(in: &subs)
        
        universe.seed(50)
    }
    
    final func update(_ time: TimeInterval, for: SKScene) {
        let delta = times.delta(time)
        if times.tick.timeout(delta) {
            universe.tick()
        }
    }
}
