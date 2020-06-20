import SpriteKit

final class Generation: SKShapeNode {
    private(set) weak var label: SKLabelNode!
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        lineWidth = 0
        zPosition = 100
        fillColor = .fadeBackground
        path = .init(roundedRect: .init(x: -40, y: -14, width: 80, height: 28), cornerWidth: 14, cornerHeight: 14, transform: nil)
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .left
        label.fontSize = Font.bold().pointSize
        label.fontName = Font.bold().fontName
        label.fontColor = .primaryText
        label.verticalAlignmentMode = .baseline
        label.horizontalAlignmentMode = .right
        label.position = .init(x: 22, y: -6)
        addChild(label)
        
        let icon = SKSpriteNode(imageNamed: "clock")
        icon.color = .primaryText
        icon.position.x = -15
        addChild(icon)
        self.label = label
    }
}
