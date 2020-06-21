import Foundation

protocol State {
    var view: View! { get }
    
    init(view: View)
    
    func render(_ time: TimeInterval)
    func add()
}

extension State {
    func render(_ time: TimeInterval) { }
    func add() { }
}

struct Playing: State {
    private(set) weak var view: View!
    
    init(view: View) {
        self.view = view
    }
    
    func render(_ time: TimeInterval) {
        let delta = view.times.delta(time)
        if view.times.tick.timeout(delta) {
            view.universe.tick()
        }
    }
    
    func add() {
        
    }
}

struct Adding: State {
    private(set) weak var view: View!
    
    init(view: View) {
        self.view = view
    }
}
