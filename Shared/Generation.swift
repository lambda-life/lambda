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
        path = .init(roundedRect: .init(x: -44, y: -14, width: 86, height: 28), cornerWidth: 14, cornerHeight: 14, transform: nil)
        position = .init(x: -80, y: -200)
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
        icon.colorBlendFactor = 1
        icon.position.x = -25
        addChild(icon)
        self.label = label
    }
}
