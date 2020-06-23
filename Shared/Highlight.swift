import SpriteKit

final class Highlight: SKNode {
    private weak var big: SKSpriteNode!
    private weak var small: SKSpriteNode!
    
    required init?(coder: NSCoder) { nil }
    init(position: CGPoint) {
        super.init()
        self.position = position
        
        let small = SKSpriteNode(imageNamed: "cell")
        small.color = .highlight
        small.size = .init(width: 8, height: 8)
        small.colorBlendFactor = 1
        small.zPosition = 2
        small.alpha = 0
        addChild(small)
        self.small = small
        
        let big = SKSpriteNode(imageNamed: "cell")
        big.color = .highlight
        big.size = .init(width: 20, height: 20)
        big.colorBlendFactor = 1
        big.zPosition = 1
        big.setScale(3)
        addChild(big)
        self.big = big
        
        big.run(.group([.fadeAlpha(to: 0.2, duration: 0.3), .scale(to: 1, duration: 0.3)]))
        small.run(.fadeAlpha(to: 1, duration: 0.3))
    }
}
