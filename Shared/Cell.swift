import SpriteKit

final class Cell: SKSpriteNode {
    var player: Player? {
        didSet {
            run(.colorize(with: player?.color ?? .clear, colorBlendFactor: 1, duration: 0.3))
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        super.init(texture: .init(imageNamed: "cell"), color: .clear, size: .init(width: radius * 2, height: radius * 2))
        colorBlendFactor = 1
    }
}
