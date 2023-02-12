import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    private var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "lightBlack"), for: .normal)
        button.backgroundColor = UIColor(named: "gray")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return button
    }()
    
    public static let identifier: String = "itemCellId"
    private var subviewConstraints: [NSLayoutConstraint] = []
    private var pressed: Bool = false {
        didSet {
            setColor()
        }
    }
    
    public var viewModel: CellViewModel? {
        didSet {
            self.button.setTitle(self.viewModel?.title, for: .normal)
            self.pressed = self.viewModel?.pressState?.pressed ?? false
            self.setColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.deactivate(self.subviewConstraints)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.subviewConstraints = [
            self.button.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.button.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.button.widthAnchor.constraint(equalToConstant: 120),
            self.button.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
        ]
        NSLayoutConstraint.activate(self.subviewConstraints)
        self.button.layer.cornerRadius = 12
        print(self.button.frame.width)
    }
    
    private func setup() {
        self.contentView.addSubview(self.button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap(sender: UIButton!) {
        if self.pressed {
            sender.backgroundColor = UIColor(named: "lightBlack")
            sender.setTitleColor(.white, for: .normal)
            self.pressed = false
        } else {
            sender.backgroundColor = UIColor(named: "gray")
            sender.setTitleColor(UIColor(named: "lightBlack"), for: .normal)
            self.pressed = true
        }
        self.viewModel?.pressState?.pressed = self.pressed 
    }
    
    private func setColor() {
        if self.pressed {
            self.button.backgroundColor = UIColor(named: "lightBlack")
            self.button.setTitleColor(.white, for: .normal)
        } else {
            self.button.backgroundColor = UIColor(named: "gray")
            self.button.setTitleColor(UIColor(named: "lightBlack"), for: .normal)
        }
    }
}
