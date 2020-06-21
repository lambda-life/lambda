import SpriteKit

final class Circle: SKNode {
    var selected = false {
        didSet {
            update()
        }
    }
    
    private weak var shadow: SKSpriteNode!
    private weak var circle: SKSpriteNode!
    private weak var texture: SKSpriteNode!
    
    required init?(coder: NSCoder) { nil }
    init(texture: String) {
        super.init()
        zPosition = 200
        
        let shadow = SKSpriteNode(imageNamed: "shadow")
        addChild(shadow)
        self.shadow = shadow
        
        let circle = SKSpriteNode(imageNamed: "circle")
        circle.colorBlendFactor = 1
        addChild(circle)
        self.circle = circle
        
        let texture = SKSpriteNode(imageNamed: texture)
        texture.colorBlendFactor = 1
        addChild(texture)
        self.texture = texture
        
        update()
    }
    
    func update() {
        shadow.isHidden = selected
        circle.color = selected ? .secondaryBackground : .background
        texture.color = selected ? .tertiaryText : .primaryText
    }
}
