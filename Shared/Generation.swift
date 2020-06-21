import SpriteKit

final class Generation: SKShapeNode {
    var count = 0 {
        didSet {
            label.text = formatter.string(from: .init(value: count))!
        }
    }
    
    private weak var label: SKLabelNode!
    private let formatter = NumberFormatter()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        lineWidth = 0
        zPosition = 100
        fillColor = .fadeBackground
        path = .init(roundedRect: .init(x: -40, y: -14, width: 80, height: 28), cornerWidth: 14, cornerHeight: 14, transform: nil)
        formatter.numberStyle = .decimal
        
        let label = SKLabelNode()
        label.horizontalAlignmentMode = .left
        label.fontSize = Font.bold().pointSize
        label.fontName = Font.bold().fontName
        label.fontColor = .primaryText
        label.verticalAlignmentMode = .baseline
        label.horizontalAlignmentMode = .left
        label.position = .init(x: -10, y: -6)
        addChild(label)
        
        let icon = SKSpriteNode(imageNamed: "clock")
        icon.color = .primaryText
        icon.position.x = -25
        addChild(icon)
        self.label = label
    }
}
