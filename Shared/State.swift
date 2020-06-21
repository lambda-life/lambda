import Foundation
import CoreGraphics

protocol State {
    var view: View! { get }
    
    init(view: View)
    
    func render(_ time: TimeInterval)
    func touch(_ point: CGPoint)
}

extension State {
    func render(_ time: TimeInterval) { }
    func touch(_ point: CGPoint) { }
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
    
    func touch(_ point: CGPoint) {
        guard addRect.contains(point) else { return }
        view.startAdd()
    }
}

struct Adding: State {
    private(set) weak var view: View!
    
    init(view: View) {
        self.view = view
    }
}
