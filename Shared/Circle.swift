import SpriteKit

final class Circle: SKShapeNode {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        lineWidth = 5
        strokeColor = .shadow
        zPosition = 200
        fillColor = .background
        path = .init(ellipseIn: .init(x: -20, y: -20, width: 40, height: 40), transform: nil)
    }
}
