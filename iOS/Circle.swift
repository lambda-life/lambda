import UIKit

final class Circle: Control {
    override var enabled: Bool {
        didSet {
            update()
        }
    }
    
    private weak var drop: UIImageView!
    private weak var circle: UIImageView!
    private weak var icon: UIImageView!
    
    required init?(coder: NSCoder) { nil }
    init(icon: String) {
        super.init()
        
        let drop = UIImageView(image: UIImage(named: "shadow")!)
        drop.translatesAutoresizingMaskIntoConstraints = false
        drop.contentMode = .center
        drop.clipsToBounds = true
        addSubview(drop)
        self.drop = drop
        
        let circle = UIImageView(image: UIImage(named: "circle")!)
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.contentMode = .center
        circle.clipsToBounds = true
        addSubview(circle)
        self.circle = circle
        
        let icon = UIImageView(image: UIImage(named: icon)!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .center
        icon.clipsToBounds = true
        addSubview(icon)
        self.icon = icon
        
        widthAnchor.constraint(equalToConstant: 60).isActive = true
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        drop.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        drop.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        circle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        update()
    }
    
    func update() {
        drop.isHidden = !enabled
        circle.tintColor = enabled ? .systemBackground : .tertiarySystemBackground
        icon.tintColor = enabled ? .label : .tertiaryLabel
    }
    
    override func hoverOn() {
        alpha = 0.3
    }
    
    override func hoverOff() {
        alpha = 1
    }
}
