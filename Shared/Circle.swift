import SpriteKit

final class Circle: SKNode {
    required init?(coder: NSCoder) { nil }
    init(texture: String) {
        super.init()
        zPosition = 200
        
        let shadow = SKSpriteNode(imageNamed: "shadow")
        addChild(shadow)
        
        let circle = SKSpriteNode(imageNamed: "circle")
        circle.color = .background
        circle.colorBlendFactor = 1
        addChild(circle)
        
        let texture = SKSpriteNode(imageNamed: texture)
        texture.color = .primaryText
        texture.colorBlendFactor = 1
        addChild(texture)
    }
}
