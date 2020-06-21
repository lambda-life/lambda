import SpriteKit
import Automata
import Combine

final class View: SKView, SKViewDelegate {
    var times = Times()
    
    private weak var generation: Generation!
    private var cells = [[Cell]]()
    private var subs = Set<AnyCancellable>()
    private let universe = Universe(size: 25)
    private let playerA = Player(color: .systemBlue)
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        delegate = self
        preferredFramesPerSecond = 3
        
        let scene = SKScene()
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        scene.physicsWorld.gravity = .zero
        scene.backgroundColor = .background
        
        let camera = SKCameraNode()
        
        let generation = Generation()
        camera.addChild(generation)
        self.generation = generation
        
        scene.addChild(camera)
        scene.camera = camera
        presentScene(scene)
        
        let add = Circle(texture: "plus")
        add.position.y = -190
        camera.addChild(add)
        
        let delta = ((CGFloat(universe.size) / 2) * 12) - 6
        cells = (0 ..< universe.size).map { x in
            (0 ..< universe.size).map { y in
                let cell = Cell(radius: 5)
                cell.position = .init(x: .init(x * 12) - delta, y: .init(y * 12) - delta)
                scene.addChild(cell)
                return cell
            }
        }
        
        universe.cell.sink { [weak self] in
            self?.cells[$0.1.x][$0.1.y].player = $0.0 as? Player
        }.store(in: &subs)
        
        universe.generation.sink {
            generation.count = $0
        }.store(in: &subs)
        
        universe.random(100, automaton: playerA)
    }
    
    func view(_: SKView, shouldRenderAtTime time: TimeInterval) -> Bool {
        let delta = times.delta(time)
        if times.tick.timeout(delta) {
            universe.tick()
        }
        return true
    }
}
