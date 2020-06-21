import SpriteKit
import Automata
import Combine

final class View: SKView, SKViewDelegate {
    var state: State!
    var times = Times()
    let universe = Universe(size: 25)
    
    private weak var generation: Generation!
    private weak var add: Circle!
    private var cells = [[Cell]]()
    private var subs = Set<AnyCancellable>()
    private let playerA = Player(color: .systemBlue)
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        delegate = self
        preferredFramesPerSecond = 3
        state = Playing(view: self)
        
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
        add.position.y = -200
        camera.addChild(add)
        self.add = add
        
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
    
    func startAdd() {
        state = Adding(view: self)
        add.selected = true
    }
    
    func view(_: SKView, shouldRenderAtTime time: TimeInterval) -> Bool {
        state.render(time)
        return true
    }
}
