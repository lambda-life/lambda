import Foundation
import CoreGraphics

protocol State {
    var view: View! { get }
    
    init(view: View)
    
    func render(_ time: TimeInterval)
    func touch(_ point: CGPoint)
    func add()
    func cancel()
}

extension State {
    func render(_ time: TimeInterval) { }
    func touch(_ point: CGPoint) { }
    func add() { }
    func cancel() { }
}

struct Playing: State {
    private(set) weak var view: View!
    private let addRect = CGRect(x: -35, y: -235, width: 70, height: 70)
    
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
        view.state = Adding(view: view)
        view.times.reset()
    }
}

struct Adding: State {
    private(set) weak var view: View!
    
    init(view: View) {
        self.view = view
    }
    
    func cancel() {
        view.state = Playing(view: view)
    }
}
