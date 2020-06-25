import UIKit

final class Button: Control {
    required init?(coder: NSCoder) { nil }
    init(icon: String, color: UIColor) {
        super.init()
        
        let icon = UIImageView(image: UIImage(named: icon)!)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .center
        icon.clipsToBounds = true
        icon.tintColor = color
        addSubview(icon)
        
        widthAnchor.constraint(equalToConstant: 50).isActive = true
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    init(text: String, background: UIColor, foreground: UIColor) {
        super.init()
        
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.isUserInteractionEnabled = false
        base.backgroundColor = background
        base.layer.cornerRadius = 16
        addSubview(base)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .medium()
        label.textColor = foreground
        addSubview(label)
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 25).isActive = true
        
        base.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        base.heightAnchor.constraint(equalToConstant: 32).isActive = true
        base.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        base.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
    }
    
    override func hoverOn() {
        alpha = 0.3
    }
    
    override func hoverOff() {
        alpha = 1
    }
}
