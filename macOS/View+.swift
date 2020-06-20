import AppKit

extension View {
    override var mouseDownCanMoveWindow: Bool { true }
    
    override func viewDidMoveToWindow() {
        align()
    }
    
    override func viewDidEndLiveResize() {
        align()
    }
}
