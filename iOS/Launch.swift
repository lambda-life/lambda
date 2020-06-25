import UIKit

final class Launch: UIViewController {
    private weak var label: UILabel?
    private weak var instructions: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        let logo = UIImageView(image: UIImage(named: "logo")!)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .center
        logo.clipsToBounds = true
        view.addSubview(logo)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = .key("Title")
        label.font = .bold(12)
        label.textColor = .systemIndigo
        view.addSubview(label)
        self.label = label
        
        let instructions = UILabel()
        instructions.translatesAutoresizingMaskIntoConstraints = false
        instructions.text = .key("Instructions")
        instructions.font = .medium(-2)
        instructions.textAlignment = .center
        instructions.numberOfLines = 0
        instructions.textColor = .tertiaryLabel
        view.addSubview(instructions)
        self.instructions = instructions
        
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
        
        let create = Button(text: .key("Create"), background: .systemIndigo, foreground: .label)
        create.target = self
        create.action = #selector(self.create)
        view.addSubview(create)
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
        label.bottomAnchor.constraint(equalTo: logo.bottomAnchor, constant: 50).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        instructions.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        instructions.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        blue.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        orange.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        orange.rightAnchor.constraint(equalTo: blue.leftAnchor, constant: -5).isActive = true
        
        pink.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        pink.leftAnchor.constraint(equalTo: blue.rightAnchor, constant: 5).isActive = true
        
        indigo.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        indigo.rightAnchor.constraint(equalTo: orange.leftAnchor, constant: -5).isActive = true
        
        teal.centerYAnchor.constraint(equalTo: blue.centerYAnchor).isActive = true
        teal.leftAnchor.constraint(equalTo: pink.rightAnchor, constant: 5).isActive = true
        
        create.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        create.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        
        select(item: blue)
        update(traitCollection)
    }
    
    override func willTransition(to: UITraitCollection, with: UIViewControllerTransitionCoordinator) {
        update(to)
    }
    
    private func update(_ trait: UITraitCollection) {
        label?.isHidden = trait.verticalSizeClass == .compact
        instructions?.isHidden = trait.verticalSizeClass == .compact
    }
    
    @objc private func select(item: Item) {
        view.subviews.compactMap { $0 as? Item }.forEach {
            $0.enabled = $0 != item
        }
    }
    
    @objc private func create() {
        present(Main(), animated: true)
//        let automaton = Main(color: contentView!.subviews.compactMap { $0 as? Item }.first { !$0.enabled }!.color)
//        automaton.center()
//        automaton.makeKeyAndOrderFront(nil)
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
