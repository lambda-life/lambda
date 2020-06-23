import Foundation

struct Times {
    struct Item {
        private var current: TimeInterval
        private let max: TimeInterval
        
        init(_ max: TimeInterval) {
            self.max = max
            current = max
        }
        
        mutating func timeout(_ with: TimeInterval) -> Bool {
            current -= with
            guard current <= 0 else { return false }
            current = max
            return true
        }
    }
    
    var tick = Item(1)
    private var last = TimeInterval()
    
    mutating func delta(_ time: TimeInterval) -> TimeInterval {
        guard last > 0 else {
            last = time
            return 0
        }
        let delta = time - last
        last = time
        return delta
    }
    
    mutating func reset() {
        last = 0
    }
}
