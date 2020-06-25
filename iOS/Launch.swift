import UIKit

final class Launch: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        let logo = UIImageView(image: UIImage(named: "logo")!)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .center
        logo.clipsToBounds = true
        view.addSubview(logo)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = .key("Title")
        title.font = .bold(12)
        title.textColor = .systemIndigo
        view.addSubview(title)
        
        let instructions = UILabel()
        instructions.translatesAutoresizingMaskIntoConstraints = false
        instructions.text = .key("Instructions")
        instructions.font = .medium(-2)
        instructions.textAlignment = .center
        instructions.numberOfLines = 0
        instructions.textColor = .tertiaryLabel
        view.addSubview(instructions)
        
        let blue = Item(color: .systemBlue)
        blue.target = self
        blue.action = #selector(select(item:))
        view.addSubview(blue)
        
        let orange = Item(color: .systemOrange)
        orange.target = self
        orange.action = #selector(select(item:))
        view.addSubview(orange)
        
        let pink = Item(color: .systemPink)
        pink.target = self
        pink.action = #selector(select(item:))
        view.addSubview(pink)
        
        let indigo = Item(color: .systemIndigo)
        indigo.target = self
        indigo.action = #selector(select(item:))
        view.addSubview(indigo)
        
        let teal = Item(color: .systemTeal)
        teal.target = self
        teal.action = #selector(select(item:))
        view.addSubview(teal)
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -10).isActive = true
        
        title.bottomAnchor.constraint(equalTo: instructions.topAnchor, constant: -5).isActive = true
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        instructions.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        instructions.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        blue.centerYAnchor.constraint(equalTo: instructions.bottomAnchor, constant: 70).isActive = true
        blue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        orange.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        orange.rightAnchor.constraint(equalTo: blue.leftAnchor, constant: -5).isActive = true
        
        pink.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        pink.leftAnchor.constraint(equalTo: blue.rightAnchor, constant: 5).isActive = true
        
        indigo.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        indigo.rightAnchor.constraint(equalTo: orange.leftAnchor, constant: -5).isActive = true
        
        teal.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        teal.leftAnchor.constraint(equalTo: pink.rightAnchor, constant: 5).isActive = true
        
        select(item: blue)
    }
    
    @objc private func select(item: Item) {
        view.subviews.compactMap { $0 as? Item }.forEach {
            $0.enabled = $0 != item
        }
    }
}

private final class Item: Control {
    override var enabled: Bool {
        didSet {
            backgroundColor = enabled ? .clear : UIColor.separator
            layer.cornerRadius = enabled ? 22 : 37
            width.constant = enabled ? 44 : 74
            circle.layer.cornerRadius = enabled ? 17 : 32
        }
    }
    
    let color: UIColor
    private weak var circle: UIView!
    private weak var width: NSLayoutConstraint!
    
    required init?(coder: NSCoder) { nil }
    init(color: UIColor) {
        self.color = color
        super.init()
        
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.isUserInteractionEnabled = false
        circle.backgroundColor = color
        circle.layer.borderColor = UIColor.systemBackground.cgColor
        addSubview(circle)
        self.circle = circle
        
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        width = widthAnchor.constraint(equalToConstant: 20)
        width.isActive = true
        
        circle.widthAnchor.constraint(equalTo: widthAnchor, constant: -10).isActive = true
        circle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
    }
    
    override func hoverOn() {
        alpha = 0.3
    }
    
    override func hoverOff() {
        alpha = 1
    }
}
