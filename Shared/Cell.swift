import SpriteKit

final class Cell: SKShapeNode {
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        super.init()
        path = .init(rect: .init(x: -radius, y: -radius, width: radius * 2, height: radius * 2), transform: nil)
        fillColor = .systemBlue
    }
}
