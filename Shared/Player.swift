import Automata
import SpriteKit

final class Player: Automaton {
    let color: SKColor
    
    init(color: SKColor) {
        self.color = color
        super.init()
    }
}
