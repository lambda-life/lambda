import SpriteKit
import Automata
import Combine

final class View: SKView, SKViewDelegate {
    var state: State!
    var times = Times()
    let universe = Universe(size: 25)
    private var cells = [[Cell]]()
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        ignoresSiblingOrder = true
        delegate = self
        
        state = Playing(view: self)
        
        let scene = SKScene()
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .background
        presentScene(scene)
        
        let delta = ((CGFloat(universe.size) / 2) * 12) - 6
        cells = (0 ..< universe.size).map { x in
            (0 ..< universe.size).map { y in
                let cell = Cell(radius: 5)
                cell.position = .init(x: .init(x * 12) - delta, y: .init(y * 12) - delta - 10)
                scene.addChild(cell)
                return cell
            }
        }
        
        universe.cell.sink { [weak self] in
            self?.cells[$0.1.x][$0.1.y].player = $0.0 as? Player
        }.store(in: &subs)
    }
    
    func view(_: SKView, shouldRenderAtTime: TimeInterval) -> Bool {
        state.render(shouldRenderAtTime)
        return true
    }
    
    func position(_ point: Point) -> CGPoint {
        cells[point.x][point.y].position
    }
    
    func clear() {
        scene!.children.compactMap { $0 as? Highlight }.forEach { $0.removeFromParent() }
    }
}
