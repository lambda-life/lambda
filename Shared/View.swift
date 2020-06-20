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
    private let playerB = Player(color: .systemPink)
    private let playerC = Player(color: .systemPurple)
    private let playerD = Player(color: .systemIndigo)
    private let playerE = Player(color: .systemOrange)
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        delegate = self
        preferredFramesPerSecond = 3
        showsFPS = true
        
        let scene = SKScene()
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .controlBackgroundColor
        scene.physicsWorld.gravity = .zero
        
        let camera = SKCameraNode()
        
        let generation = Generation()
        camera.addChild(generation)
        self.generation = generation
        
        scene.addChild(camera)
        scene.camera = camera
        presentScene(scene)
        
        let delta = (CGFloat(universe.size) / 2) * 12
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
            generation.label.text = "\($0)"
        }.store(in: &subs)
        
        universe.random(25, automaton: playerA)
        universe.random(25, automaton: playerB)
        universe.random(25, automaton: playerC)
        universe.random(25, automaton: playerD)
        universe.random(25, automaton: playerE)
    }
    
    func view(_: SKView, shouldRenderAtTime time: TimeInterval) -> Bool {
        let delta = times.delta(time)
        if times.tick.timeout(delta) {
            universe.tick()
        }
        return true
    }
    
    func align() {
        generation.position = .init(x: ((scene!.frame.width - 80) / -2) + 30, y: ((scene!.frame.height - 28) / -2) + 30)
    }
}
