import SpriteKit

final class Cell: SKSpriteNode {
    var player: Player? {
        didSet {
            color = player?.color ?? .clear
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        super.init(texture: .init(imageNamed: "cell"), color: .clear, size: .init(width: radius * 2, height: radius * 2))
        colorBlendFactor = 1
    }
}
