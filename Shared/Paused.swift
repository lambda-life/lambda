import SpriteKit

final class Paused: SKShapeNode {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        lineWidth = 0
        zPosition = 100
        fillColor = .fadeBackground
        path = .init(roundedRect: .init(x: -60, y: -18, width: 120, height: 36), cornerWidth: 18, cornerHeight: 18, transform: nil)
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .left
        label.fontSize = Font.bold(2).pointSize
        label.fontName = Font.bold(2).fontName
        label.fontColor = .primaryText
        label.text = .key("Paused")
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        addChild(label)
    }
}
