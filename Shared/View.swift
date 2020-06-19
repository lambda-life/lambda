import SpriteKit
import Automata
import Combine

final class View: SKView, SKSceneDelegate {
    var times = Times()
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
    }
    
    final func update(_ time: TimeInterval, for: SKScene) {
        let delta = times.delta(time)
        if times.tick.timeout(delta) {

        }
    }
}
